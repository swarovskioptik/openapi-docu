# EXIF Field Descriptions

<BR>
## General Information


| EXIF Tag          | Format                                   | Comment                     |
| ----------------- | ---------------------------------------- | --------------------------- |
| ImageDescription  | detailed is described below              | detailed is described below |
| Make              | "Swarovski Optik"                        |                             |
| Camera Model Name | "AX VISIO 10x32"                         |                             |
| File Name         | AX VISIO_AXV_yyyyMMdd-HHmmSS.fff.jpg/mp4 |                             |
| Orientation       | e.g. Horizontal (normal)                 |                             |
| Software          | e.g. "com.swarovskioptik.cameraapp"      | package name of Inside App  |
| Compression       | The compression type.                    | jpeg/H.264                  |
| FileSize          | e.g. 6 MB                                | file size in Megabyte       |

<BR>
## Date and Time Information


| EXIF Tag           | Format              | Comment                                                          |
| ------------------ | ------------------- | ---------------------------------------------------------------- |
| Create Date        | YYYY:MM:DD HH:mm:ss | Date&Time based on current timezone! e.g.: “2024:05:27 08:17:48” |
| Date/Time Original | YYYY:MM:DD HH:mm:ss | e.g.: “2024:05:27 08:17:48”                                      |

<BR>
## Location Information


| EXIF Tag        | Format                   | Comment                                                                       |
| --------------- | ------------------------ | ----------------------------------------------------------------------------- |
| GPSLatitude     | e.g. 47 deg 14' 37.37" N | Indicates the latitude. The latitude is expressed as three RATIONAL values.   |
| GPSLatitudeRef  | e.g. North               | Indicates whether the latitude is north or south latitude.                    |
| GPSLongitude    | e.g. 11 deg 17' 30.25" E | Indicates the longitude. The longitude is expressed as three RATIONAL values. |
| GPSLongitudeRef | e.g. East                | Indicates whether the longitude is east or west longitude.                    |
| GPSAltitude     | e.g. 835 m               | Indicates the altitude based on the reference in GPSAltitudeRef.              |
| GPSAltitudeRef  | e.g. Above Sea Level     | Indicates the altitude used as the reference altitude.                        |
| GPSImgDirection | e.g. 347.96              | The direction of the image when it was captured (in degrees).                 |

<BR>
## Camera Settings


| EXIF Tag                 | Format                      | Comment                                                                   |
| ------------------------ | --------------------------- | ------------------------------------------------------------------------- |
| FNumber                  | unsigned rational e.g. 2.2  | The actual F-number(F-stop) of lens when the image was taken.             |
| ApertureValue            | unsigned rational           | The actual aperture value of lens when the image was taken.               |
| MaxApertureValue         | unsigned rational           | The smallest F of the lens (in APEX units).                               |
| FocalLength              | unsigned rational           | Focal length of lens used to take image.                                  |
| ISO                      |                             | unused - Falke Iso value in tag "ISO speed"                               |
| ISOSpeed                 | unsigned rational           |                                                                           |
| ExposureTime             | e.g. 1/526 sec              | The exposure time (in seconds).                                           |
| DeviceSettingDescription | unsigned rational           | Elevation (positive value)/depression(negative value).                    |
| SubjectDistance          | unsigned rational           | The approximate distance to the subject (in meters).                      |
| SubjectArea              | detailed is described below | Indicates the location and area of the main subject in the overall scene. |

<BR>
## Image Characteristics


| EXIF Tag                  | Format                                       | Comment                                                                              |
|---------------------------|----------------------------------------------|--------------------------------------------------------------------------------------|
| BitsPerSample             | unsigned short/long                            | When image format is no compression, this value shows the number of bits per component for each pixel.                                                                                    |
| ImageHeight                | unsigned short/long                          | Shows size of thumbnail image.
| ImageWidth                | unsigned short/long                          | Shows size of thumbnail image.                                                                                     |
| ExifImageHeight           | unsigned short/long                          | Size of main image.
| ExifImageWidth           | unsigned short/long                           | Size of main image.                                                                                  |
| ColorSpace                | unsigned short                               | The color space of the image.                                                        |
| YCbCrPositioning          | unsigned short                               | 2 (Co-sited)                                                                         |
| XResolution               | unsigned rational                            | The horizontal resolution of the image in DPI.                                       |
| YResolution               | unsigned rational                            | The vertical resolution of the image in DPI.                                         |

<BR>
## Video Specific Information


| EXIF Tag                  | Format                                       | Comment                                                                              |
|---------------------------|----------------------------------------------|--------------------------------------------------------------------------------------|
| Duration                  | e.g. 5 sec                                   | Duration of the video in seconds                                                                                     |
| Video Frame Rate          | e.g. 30 fps                                  | Frame rate of the Video per second                                                                                      |

<BR>
## Detailed Format Description for SubjectArea

<BR>
<BR>
### SubjectArea


Indicates the location and area of the main subject in the overall scene.

The subject location and area are defined by Count values as follows:  
Count = 2: Indicates the location of the main subject as coordinates. The first value is the X coordinate and the second is the Y coordinate.  
Count = 3: The area of the main subject is given as a circle. The circular area is expressed as center coordinates and diameter. The first value is the center X coordinate, the second is the center Y coordinate, and the third is the diameter.  
**Count = 4: The area of the main subject is given as a rectangle. The rectangular area is expressed as center coordinates and area dimensions. The first value is the center X coordinate, the second is the center Y coordinate, the third is the width of the area, and the fourth is the height of the area. (current used version)**

Note that the coordinate values, width, and height are expressed in relation to the upper left as origin, prior to rotation processing as per the Rotation tag.

<BR>
## Detailed Format Description for ImageDescription

**BirdID:**


Format: Top1CommonName|species id list (values separated by comma)|confidence list (values separated by comma)

Example:
- Canada Goose: cangoo|0.97128838|0.78138983|2158,1950,617,423|shaking|StartFocus|detSegments:0|finalSegments:1|filteredByGPS


**Wildlife ID:**


Format: Top1CommonName|species list (values separated by comma)|confidence list (values separated by comma)

Example:
- Cervus nippon: Cervus nippon,Dama dama,Cervus elaphus,Axis axis,Odocoileus virginianus|0.91542685,0.058428057,0.020147795,0.0040012943,0.0019829927