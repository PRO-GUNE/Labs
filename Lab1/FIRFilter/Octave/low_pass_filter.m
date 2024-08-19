# This is an octave script that implements the FIR algorithm for image sharpening.
# The script performs vertical sharpening and horizontal sharpening separately and then combines the two results to get the final sharpened image.
pkg load signal
pkg load image

# FIR filter coefficients derived as 16 bit integers
coefficients = [621,1252,955,-464,-1427,-442,1279,815,-2028,-2978,1849,9985,14052,9985,1849,-2978,-2028,815,1279,-442,-1427,-464,955,1252,621]
freqz(coefficients,1,512)

# Let the amplification factor be 1 then the resultin coefficients are
filter = 1 * coefficients/(2^15);

# load the file and apply the sharpness filter
img_in = imread("image_720p.jpg");
img_out = imfilter(img_in, filter);

# write as ppm format
write_ascii_ppm(img_in, "image_720p.ppm");
write_ascii_ppm(img_out, "image_expected.ppm");


