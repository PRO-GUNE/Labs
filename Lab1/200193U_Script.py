import cv2
import numpy as np
import matplotlib.pyplot as plt

# Index number
index_number = "200193U"

########################################################################################
# Step 1 - Load an image from the disk and convert it to gray-scale
image_path = "test.png"
image = cv2.imread(image_path, cv2.IMREAD_GRAYSCALE)

# Save the original grayscale image
cv2.imwrite(f"{index_number}_org.png", image)

########################################################################################

# Step 2 - Rotate the image by 45 degrees anticlockwise around its center
(height, width) = image.shape
center = (width // 2, height // 2)

# Create rotation matrix
angle = np.radians(45)
cos_angle = np.cos(angle)
sin_angle = np.sin(angle)

# Rotation matrix for around the center
rotation_matrix = np.array(
    [
        [
            cos_angle,
            -sin_angle,
            center[0] - center[0] * cos_angle + center[1] * sin_angle,
        ],
        [
            sin_angle,
            cos_angle,
            center[1] - center[0] * sin_angle - center[1] * cos_angle,
        ],
    ]
)

# Create the coordinate grid
y_indices, x_indices = np.indices((height, width))
x_indices_flat = x_indices.flatten()
y_indices_flat = y_indices.flatten()

# Homogeneous coordinates
homogeneous_coordinates = np.stack(
    [x_indices_flat, y_indices_flat, np.ones_like(x_indices_flat)]
)

# Rotate the coordinates
rotated_coordinates = rotation_matrix @ homogeneous_coordinates  # Matrix multiplication

# Interpolating the pixel values at the rotated coordinates
rotated_image = np.zeros_like(image)
x_rotated = rotated_coordinates[0, :].reshape(height, width).astype(int)
y_rotated = rotated_coordinates[1, :].reshape(height, width).astype(int)

# Validating the coordinates to stay within bounds
valid_indices = (
    (x_rotated >= 0) & (x_rotated < width) & (y_rotated >= 0) & (y_rotated < height)
)
rotated_image[valid_indices] = image[y_rotated[valid_indices], x_rotated[valid_indices]]

# Save the rotated image
cv2.imwrite(f"{index_number}_rotated.png", rotated_image)

########################################################################################

# Step 3 - Create an image pyramid having 5 levels
pyramid = [image]

# Save the original image as level 1 pyramid
cv2.imwrite(f"{index_number}_pyramid_1.png", pyramid[0])

for i in range(5):
    # Averaging blocks of pixels to perform downsampling
    image = (
        image.reshape((image.shape[0] // 2, 2, image.shape[1] // 2, 2))
        .mean(axis=(1, 3))
        .astype(np.uint8)
    )
    pyramid.append(image)

    # Save imge at each level of the pyramid
    cv2.imwrite(f"{index_number}_pyramid_{i+1}.png", image)

########################################################################################


# Step 4 - Magnify the third level image by four times using bilinear interpolation
def bilinear_interpolate(img, x, y):
    x0 = np.floor(x).astype(int)
    y0 = np.floor(y).astype(int)
    x1 = x0 + 1
    y1 = y0 + 1

    x0 = np.clip(x0, 0, img.shape[1] - 1)
    y0 = np.clip(y0, 0, img.shape[0] - 1)
    x1 = np.clip(x1, 0, img.shape[1] - 1)
    y1 = np.clip(y1, 0, img.shape[0] - 1)

    Ia = img[y0, x0]
    Ib = img[y1, x0]
    Ic = img[y0, x1]
    Id = img[y1, x1]

    wa = (x1 - x) * (y1 - y)
    wb = (x1 - x) * (y - y0)
    wc = (x - x0) * (y1 - y)
    wd = (x - x0) * (y - y0)

    return wa * Ia + wb * Ib + wc * Ic + wd * Id


# Upsampling coordinates for the third level image
x_indices = np.linspace(0, pyramid[2].shape[1] - 1, width)
y_indices = np.linspace(0, pyramid[2].shape[0] - 1, height)
x_indices, y_indices = np.meshgrid(x_indices, y_indices)

magnified_image = bilinear_interpolate(pyramid[2], x_indices, y_indices).astype(
    np.uint8
)

# Save the magnified image
cv2.imwrite(f"{index_number}_mag.png", magnified_image)

########################################################################################

# Step 5 - Compute the difference image between the original image and the interpolated image created above
difference_image = np.abs(
    pyramid[0].astype(np.int16) - magnified_image.astype(np.int16)
).astype(np.uint8)

# Save the difference image
cv2.imwrite(f"{index_number}_diff.png", difference_image)

# Display the images for visualization purposes
plt.figure(figsize=(10, 10))
plt.subplot(2, 2, 1)
plt.title("Original Image")
plt.imshow(pyramid[0], cmap="gray")

plt.subplot(2, 2, 2)
plt.title("Rotated Image")
plt.imshow(rotated_image, cmap="gray")

plt.subplot(2, 2, 3)
plt.title("Magnified Image (3rd level scaled 4x)")
plt.imshow(magnified_image, cmap="gray")

plt.subplot(2, 2, 4)
plt.title("Difference Image")
plt.imshow(difference_image, cmap="gray")

plt.show()

########################################################################################

# Step 6: Comment on the properties of the difference image

# The difference image highlights areas where the interpolated image differs from the original.
# Due to the rescaling and interpolation, edges and high-frequency details will likely show the most difference,
# indicating loss of sharpness or slight shifts in pixel intensity. Bilinear interpolation smooths the image,
# which is why the differences might appear as blurred versions of the edges.
# If observed closely, we can identify that the edges of the difference image are more prominent, indicating
# the presence of high-frequency components in the original image. This is because the bilinear interpolation
# method used to magnify the image does not preserve the sharpness of the original image.

########################################################################################
