# PHP-Dlib

PHP extension for the Dlib C++ library (face detection, landmarks, recognition, and clustering).

This project is a fork of the original **pdlib** and extends it with improved build support and modern Dlib versions.

---

## 🚀 Features

- ✅ Face Detection (HOG / CNN)
- ✅ Facial Landmark Detection
- ✅ Face Recognition (128D descriptors)
- ✅ Deep Learning-based face detection (CNN)
- ✅ Chinese Whispers clustering (graph-based grouping)



## PHP Dlib Extension Quick Installation Guide
[Tutorial](https://dev.to/arshidkv12/develop-a-pure-php-face-recognition-application-313n)

### 1. Download the Extension
Download the correct file from: [Releases](https://github.com/mailmug/php-dlib/releases)


Choose:
- Windows → `.dll`
- Linux → `.so`
- Mac → `.so`

Make sure it matches:
- PHP version (8.2 / 8.3 / 8.5)
- Thread Safe (TS) or Non-Thread Safe (NTS)
- Architecture (x64 / x86)


#### 2. Windows Installation (.dll)

##### Find php.ini

Create file:
```php
<?php phpinfo();
```

Open: `http://localhost/info.php` Then check: `Loaded Configuration File (php.ini)`. 

Finally, add the following code to the `php.ini` file
```bash
extension="/path/to/dlib.dll"
```
Then restart the server. Finished :) 

## Requirements
- Dlib 20+
- C++14
- libx11-dev (on Ubuntu: `sudo apt-get install libx11-dev`)

## Recommended
- BLAS library  
If no BLAS library found - dlib's built-in BLAS will be used.
However, if you install an optimized BLAS such as OpenBLAS or the Intel MKL your code
will run faster.  On Ubuntu, you can install OpenBLAS by executing:
`sudo apt-get install libopenblas-dev liblapack-dev`

## Dependencies

### Dlib

Install Dlib as a shared library

```bash
clone --branch v20.0.1 --depth 1 https://github.com/davisking/dlib.git
cd dlib/dlib
mkdir build
cd build
cmake -DBUILD_SHARED_LIBS=ON ..
make
sudo make install
```

## Installation

```bash
git clone https://github.com/mailmug/php-dlib.git
cd php_dlib
phpize
./configure --enable-debug
# You may need to indicate the dlib install location
# PKG_CONFIG_PATH=/usr/local/lib/pkgconfig ./configure --enable-debug
make
sudo make install
```

### Configure PHP installation

```bash
vim your-path/php.ini
```

Append the content below to `php.ini`

```
[php_dlib]
extension="php_dlib.so"
```

## Tests

For tests, you will need to have the bz2 extension installed. On Ubuntu, it boils down to:
```bash
sudo apt-get install php-bz2
```

After you have successfully compiled everything, just run:
```bash
make test
```

## Usage

### General Usage

A good starting point can be `tests/integration_face_recognition.phpt`. Check that first.

Basically, if you just want to quickly get from your image to a 128D descriptor of faces in the image,
here is a really minimal example of how:

```php
<?php
$img_path = "image.jpg";
$fd = new CnnFaceDetection("detection_cnn_model.dat");
$detected_faces = $fd->detect($img_path);
foreach($detected_faces as $detected_face) {
  $fld = new FaceLandmarkDetection("landmark_model.dat");
  $landmarks = $fld->detect($img_path, $detected_face);
  $fr = new FaceRecognition("recognition_model.dat");
  $descriptor = $fr->computeDescriptor($img_path, $landmarks);
  // Optionally use descriptor later in `dlib_chinese_whispers` function
}
```

Location from where to get these models can be found on the DLib website, as well as in `tests/integration_face_recognition.phpt` test.

### Specific use cases

#### face detection

If you want to use the HOG-based approach:

```php
<?php

// face detection
detected_faces = dlib_face_detection("image.jpg");
// $detected_faces is an indexed array, where values are assoc arrays with "top", "bottom", "left" and "right" values
```

If you want to use the CNN approach (and CNN model):

```php
<?php
$fd = new CnnFaceDetection("detection_cnn_model.dat");
$detected_faces = $fd->detect("image.jpg");
// $detected_face is an indexed array, where values are assoc arrays with "top", "bottom", "left", and "right" values
```
The CNN model can get you slightly better results, but is much, much more demanding (CPU and memory, GPU is also preferred).

#### face landmark detection

```php
<?php

// face landmark detection
$landmarks = dlib_face_landmark_detection("~/a.jpg");
var_dump($landmarks);
```

Additionally, you can also use a class-based approach:
```php
$rect = array("left"=>value, "top"=>value, "right"=>value, "bottom"=>value);
// You can download a trained facial shape predictor from:
// http://dlib.net/files/shape_predictor_5_face_landmarks.dat.bz2
$fld = new FaceLandmarkDetection("path/to/shape/predictor/model");
$parts = $fld->detect("path/to/image.jpg", $rect);
// $parts is integer array where keys are associative values with "x" and "y" for keys
```

Note that, if you use a class-based approach, you need to feed the bounding box rectangle with values obtained from `dlib_face_detection`. If you use `dlib_face_landmark_detection`, everything is already done for you (and you are using the HOG face detection model).

#### face recognition (aka getting face descriptor)

```php
<?php

$fr = new FaceRecognition($model_path);
$landmarks = array(
    "rect" => $rect_of_faces_obtained_with_CnnFaceDetection,
    "parts" => $parts_obtained_with_FaceLandmarkDetection);
$descriptor = $fr->computeDescriptor($img_path, $landmarks);
// $descriptor is 128D array
```

#### Chinese whispers

Provides raw access to dlib's `chinese_whispers` function.
The client needs to build and provide edges. Edges are provided
as a numeric array. Each element of this array should also be a numeric array with 2 elements of long type.

Returned value is also a numeric array, containing obtained labels.

```php
<?php
// This example will cluster nodes 0 and 1, but would leave 2 out.
// $labels will look like [0,0,1].
$edges = [[0,0], [0,1], [1,1], [2,2]];
$labels = dlib_chinese_whispers($edges);
```

## Features
- [x] 1. Face Detection
- [x] 2. Face Landmark Detection
- [x] 3. Deep Face Recognition
- [x] 4. Deep Learning Face Detection
- [x] 5. Raw chinese_whispers

