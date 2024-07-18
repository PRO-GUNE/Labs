# This is an octave script that implements the FIR algorithm for image sharpening.
# The script performs vertical sharpening and horizontal sharpening separately and then combines the two results to get the final sharpened image.
pkg load signal
pkg load image

# Filter : medium size high pass filter - 50%
coefficients = fir1(8, 0.5, "high");

# Round off values for efficient implementation so that +3, -3 coefficients are approximately 1. +4, -4 are nearly 0
coefficients = round(32 * coefficients);

# drop the last and first coefficient
coefficients = coefficients(2:end-1);

# Let the amplification factor be 1 then the resultin coefficients are
sig_i = zeros(1, 7);
sig_i(4) = 1;
filter = sig_i + 1 * coefficients/32;

# Plot the filter
freqz(filter)

# load the file and apply the sharpness filter
img = imread("images.jpeg");
f_hor = filter;
f_ver = filter';

img_1 = imfilter(img, f_hor);
img_final = imfilter(img_1, f_ver);

imwrite(img_final, "sharpened_image.jpeg");

