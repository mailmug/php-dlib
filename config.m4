PHP_ARG_WITH(php_dlib, for php_dlib support,
[  --with-php-dlib   Include php_dlib support])

if test "$PHP_PHP_DLIB" != "no"; then
  PHP_REQUIRE_CXX()

  PHP_ADD_LIBRARY(stdc++, 1, PHP_DLIB_SHARED_LIBADD)
  PHP_SUBST(PHP_DLIB_SHARED_LIBADD)

  php_dlib_src_files="php_dlib.cpp \
  src/chinese_whispers.cpp \
  src/face_detection.cpp \
  src/face_landmark_detection.cpp \
  src/face_recognition.cpp \
  src/cnn_face_detection.cpp \
  src/vector.cpp"

  AC_PATH_PROG(PKG_CONFIG, pkg-config, no)
  if test -x "$PKG_CONFIG"; then
    if $PKG_CONFIG --exists dlib-1; then
      if $PKG_CONFIG dlib-1 --atleast-version 19.00; then
        LIBDLIB_CFLAGS=`$PKG_CONFIG dlib-1 --cflags`
        LIBDLIB_LIBS=`$PKG_CONFIG dlib-1 --libs`
      else
        AC_MSG_ERROR(dlib too old)
      fi
    else
      AC_MSG_ERROR(dlib-1 not found)
    fi
  else
    AC_MSG_ERROR(pkg-config not found)
  fi

  PHP_EVAL_INCLINE($LIBDLIB_CFLAGS)
  PHP_EVAL_LIBLINE($LIBDLIB_LIBS, PHP_DLIB_SHARED_LIBADD)

  PHP_NEW_EXTENSION(php_dlib, $php_dlib_src_files, $ext_shared,, -std=c++14, cxx)
fi