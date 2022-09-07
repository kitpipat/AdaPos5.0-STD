<html>

  <head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><?php echo language('adawallet/main/main', 'tTopup'). " " . language('adawallet/main/main', 'tAdw') ?></title>


  </head>

  <body>

    <div class="container justify-content-center p-0 m-0" id="odvQrCode">
      <div class="row ่justify-content-center mt-5">
        <div class="col-12 text-center">
          <h3><b><?php echo language('adawallet/main/main', 'tQrcodeTopup') ?></b></h3>
        </div>
      </div>
      <div class="row">
        <div class="col-12">
          <img name="oimPreview" id="oimPreview" src="<?php echo base_url().'application/modules/adawallet/assets/images/qrcode/Qr_'. $ptAmount . "_" . $ptInvID . ".jpeg"?>" class="img-responsive pt-2 pb-0" width="100%">
          <input type="hidden" id="ohdNameImg" value="<?php echo "Qr_". $ptAmount . "_" . $ptInvID . ".jpeg"?>">
        </div>

      </div>

    </div>

 
  <!-- Include from the CDN -->
  <!-- <script src="https://cdn.jsdelivr.net/npm/html2canvas@1.0.0-rc.5/dist/html2canvas.min.js"></script> -->
  <script src="https://cdnjs.cloudflare.com/ajax/libs/html2canvas/1.3.4/html2canvas.min.js"></script>
    <script>


      function JSxADWScreenshot() {
        let oimPreview = document.getElementById('oimPreview');
        html2canvas(oimPreview).then((canvas)=>{
            let oahDownload = document.createElement("a");
            
            var tImgName = document.getElementById("ohdNameImg").value;
            oahDownload.download = tImgName;
            oahDownload.href = canvas.toDataURL("image/jpeg");
            oahDownload.click();

            $.ajax({
              url: "<?php echo base_url('adwADWEventUnlinkImage/') ?>",
              type: "POST",
              data: {
                "ptImgName": tImgName
              },
              dataType: "json",
              cache: false,
              success: function(data) {
                // liff.closeWindow();
                window.close();
              }
            });
          });
      }


      JSxADWScreenshot();
    </script>
  </body>

</html>