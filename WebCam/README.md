# ESP32Camera

  You can configure the Access Point name chaniging this line:   WiFi.softAP("ESP32-CAM Portal");
  The framesize is configured with this line:   s->set_framesize(s, FRAMESIZE_UXGA);
  The frame options are:
  
  <option value="10">UXGA(1600x1200)</option><p>
  <option value="9">SXGA(1280x1024)</option><p>
  <option value="8">XGA(1024x768)</option><p>
  <option value="7">SVGA(800x600)</option><p>
  <option value="6">VGA(640x480)</option><p>
  <option value="5">CIF(400x296)</option><p>
  <option value="4">QVGA(320x240)</option><p>
  <option value="3">HQVGA(240x176)</option><p>
  <option value="0">QQVGA(160x120)</option><p>
