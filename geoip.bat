@echo off
REM Title       : Search GeoIP
REM Description : Location search using wireshark's geoip.
REM How to Use  : ./geoip.bat [IP]
REM Maker       : LT
REM Date        : 2019.8.20.
REM OS          : Windows



IF "%1"=="-h" (
	echo %0 [IP]
) ELSE (
	echo %1 | [Wireshark Path]\WiresharkPortable\App\Wireshark\mmdbresolve.exe -f [Wireshark Path]\WiresharkPortable\GeoLite2-Country\GeoLite2-ASN.mmdb | findstr "autonomous_system_organization autonomous_system_number"
	echo.
	echo %1 | [Wireshark Path]\WiresharkPortable\App\Wireshark\mmdbresolve.exe -f [Wireshark Path]\WiresharkPortable\GeoLite2-Country\GeoLite2-City.mmdb | findstr "country.iso_code country.names.en location.latitude location.longitude location.accuracy_radius"
)
