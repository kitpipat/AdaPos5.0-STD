<html>

  <head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><?php echo language('adawallet/main/main', 'tCheckBal') . " / " . language('adawallet/main/main', 'tTopup'). " " . language('adawallet/main/main', 'tAdw') ?></title>
  </head>

  <body>
    <div class="container mt-3 mb-2">
      <div class="row">
        <div class="col align-self-center xWMenu">
          <?php echo language('adawallet/main/main', 'tProgram') . " : " . language('adawallet/main/main', 'tCheckBal') . " / " . language('adawallet/main/main', 'tTopup') . " " . language('adawallet/main/main', 'tAdw') ?>
        </div>
        <div class="col-auto">
          <div class="sl-nav">
            <ul>
              <li><i class="bi bi-globe"></i>
                <div class="triangle"></div>
                <ul>
                  <li>
                    <a href="?lang=th"> <?php echo language('adawallet/main/main', 'tthai') ?> </a>
                  </li>
                  <li>
                    <a href="?lang=en"> <?php echo language('adawallet/main/main', 'teng') ?> </a>
                  </li>
                </ul>
              </li>
            </ul>
          </div>
        </div>
      </div>
    </div>

    <div class="container" id="odvCheckandTop">

      <!-- เช็คยอดเงิน -->
      <div class="row justify-content-center">
        <div class="col-md-12 mb-2" id="odvCheckbalance">
          <div class="card mt-2">
            <div class="card-body xWCard">
              <div class="row align-items-center justify-content-between">
                <div class="col-auto">
                  <h3 class="card-text"><?php echo language('adawallet/main/main', 'tAdw') ?></h3>
                </div>
                <div class="col-auto "> 
                  <p id="obpCardtype" class="card-subtitle text-muted"><?php echo language('adawallet/main/main', 'tCardTyp') ?></p>
                </div>
              </div>
              <p id="obpNoti"><?php echo language('adawallet/main/main', 'tNoti') ?></p>
              <p id="obpCardno" class="card-subtitle mb-1 text-muted"><?php echo language('adawallet/main/main', 'tRefNo') ?></p>
              <p id="obpBal" class="card-subtitle mt-1 text-muted"><?php echo language('adawallet/main/main', 'tBalance') ?> (<?php echo language('adawallet/main/main', 'tTHB') ?>) </p>
              <h3 id="obpBalance" class="card-text"></h3>
            </div>
          </div>
        </div>
      </div>
      <!-- end เช็คยอดเงิน -->

      <!-- เติมเงิน -->
      <div id="odvTopup">
        <div class="row my-2 mx-1 p-0">
              <h5><?php echo language('adawallet/main/main', 'tTopup') ?></h5>
        </div>

        <!-- เลือกจำนวนเงิน -->
        <div class="row justify-content-center my-2 mx-1 p-0">
          <div class="col mx-1 p-0">
            <input type="submit" name="oetMoney" id="oetMoney" class="btn xWBtnMoney" value="20" onclick="JStADWMoney(this.value)"/>
          </div>

          <div class="col mx-1 p-0">
            <input type="submit" name="oetMoney" id="oetMoney" class="btn xWBtnMoney" value="50" onclick="JStADWMoney(this.value)" />
          </div>

          <div class="col mx-1 p-0">
            <input type="submit" name="oetMoney" id="oetMoney" class="btn xWBtnMoney" value="100" onclick="JStADWMoney(this.value)"/>
          </div>

          <div class="col mx-1 p-0">
            <input type="button" name="oetMoney" id="oetMoney" class="btn xWBtnMoney" value="150" onclick="JStADWMoney(this.value)"/>
          </div>
        </div>

        <div class="row justify-content-center my-2 mx-1 p-0">
          <div class="col mx-1 p-0">
            <input type="submit" name="oetMoney" id="oetMoney" class="btn xWBtnMoney" value="200" onclick="JStADWMoney(this.value)"/>
          </div>
          
          <div class="col mx-1 p-0">
            <input type="submit" name="oetMoney" id="oetMoney" class="btn xWBtnMoney" value="300" onclick="JStADWMoney(this.value)" />
          </div>

          <div class="col mx-1 p-0">
            <input type="submit" name="oetMoney" id="oetMoney" class="btn xWBtnMoney" value="500" onclick="JStADWMoney(this.value)"/>
          </div>

          <div class="col mx-1 p-0">
            <input type="button" name="oetMoney" id="oetMoney" class="btn xWBtnMoney" value="1000" onclick="JStADWMoney(this.value)"/>
          </div>
        </div>
        <!-- end เลือกจำนวนเงิน -->

        <div class="row my-2 mx-1 p-0">
          <input type="number" class="form-control xWInput xWTopup" name="onbMoney" id="onbMoney" placeholder="0" onkeyup="JStCheckMoney()">
        </div>

        <!-- เงื่อนไขการเติมเงิน -->
        <div class="row my-2 mx-1 p-0">
          <div class="col-12 px-1">
            <p class="mb-0"><b><?php echo language('adawallet/main/main', 'tRequireTopup') ?></b></p>
          </div>
        </div>

        <div class="row mx-1 p-0">
          <div class="col-12 px-1">
            <div class="form-check mx-2">
              <input class="form-check-input xWCheckbox" type="checkbox" id="ocbRequireDetailBank" value="<?php echo language('adawallet/main/main', 'tRequireDetailAmount') ?>">
              <label class="form-check-label" for="ocbRequireDetailBank"><p class="text-justify mb-0"><?php echo language('adawallet/main/main', 'tRequireDetailBank') ?></p></label>
            </div>
          </div>
        </div>

        <div class="row mx-1 p-0">
          <div class="col-12 px-1">
            <div class="form-check mx-2">
              <input class="form-check-input xWCheckbox" type="checkbox" id="ocbRequireDetailAmount" value="<?php echo language('adawallet/main/main', 'tRequireDetailAmount') ?>">
              <label class="form-check-label" for="ocbRequireDetailAmount"><p class="text-justify mb-0"><?php echo language('adawallet/main/main', 'tRequireDetailAmount') ?></p></label>
            </div>
          </div>
        </div>
        
        <div class="row mx-1 p-0">
          <div class="col-12 px-1">
            <div class="form-check mx-2">
              <input class="form-check-input xWCheckbox" type="checkbox" id="ocbRequireDetailQrcode" value="<?php echo language('adawallet/main/main', 'tRequireDetailQrcode') ?>">
              <label class="form-check-label" for="ocbRequireDetailQrcode"><p class="text-justify mb-0"><?php echo language('adawallet/main/main', 'tRequireDetailQrcode') ?></p></label>
            </div>
          </div>
        </div>

        <div class="row mx-1 p-0">
          <div class="col-12 px-1">
            <div class="form-check mx-2">
              <input class="form-check-input xWCheckbox" type="checkbox" id="ocbRequireDetailExpire" value="<?php echo language('adawallet/main/main', 'tRequireDetailExpire') ?>">
              <label class="form-check-label" for="ocbRequireDetailExpire"><p class="text-justify"><?php echo language('adawallet/main/main', 'tRequireDetailExpire') ?></p></label>
            </div>
          </div>
        </div>
        <!-- end เงื่อนไขการเติมเงิน -->

        <div class="row my-2 mx-1 p-0">
          <input type="button" class="btn xWBtnMain mb-3" name="osmNext" id="osmNext" data-toggle="modal" data-target="#odvTopupConfirmModal" value="<?php echo language('adawallet/main/main', 'tNext') ?>" disabled>
        </div>
      </div>
      <!-- end เติมเงิน -->
    </div>

    <div class="container" id="odvGenqr">

      <div class="container" id="odvQrCode">
        <div class="row justify-content-center" id="oImgQR">
          <div class="col">
            <img name="oimQR" id="oimQR" class="rounded mt-3 mx-auto d-block" src="<?php echo base_url().'/application/modules/adawallet/assets/images/qrcode_topup.png'?>">
          </div>
        </div>

        <div class="row justify-content-center p-0 xWBorder" id="odvShowOtp">
            <div class="col-10 text-center mx-auto">
                <h5 id="obhAmount" class="p-1 mb-0"></h5>
            </div>
        </div>

        <div class="row justify-content-center xWBorder">
            <div class="col-12 text-center">
                <p id="obpInvoiceID" class="mb-0"></p>
            </div>
        </div>
      </div>
 
      <div class="row justify-content-center xWBorder">
        <div class="col-8 text-center xWBorder">
          <input type="submit" name="osmFinish" id="osmFinish" value="<?php echo language('adawallet/main/main', 'tDownloadQrcode') ?>" class="btn xWBtnMain mx-auto mt-5 mb-0" onclick="JSxADWScreenshot();">
        </div>
      </div>

      <div class="row justify-content-center xWBorder">
        <div class="col-10 pb-0 mt-2 text-center">
          <p id="obpTopupNoti" class="mb-3"><?php echo language('adawallet/main/main', 'tCapture') ?></p>
        </div>
      </div>

      <div class="row justify-content-center xWBorder">
        <div class="col-8 xWBorder">
          <!-- <input type="submit" name="osmFinish" id="osmFinish" value="<?php echo language('adawallet/main/main', 'tFinish') ?>" class="btn xWBtnMain mx-auto" onclick="liff.closeWindow();"> -->
          <input type="submit" name="osmCancel" id="osmCancel" value="<?php echo language('adawallet/main/main', 'tCancel') ?>" class="btn xWBtnCancel mx-auto">
        </div>
      </div>

    </div>

    <div class="container" id="odvCancelTopup">

      <div class="row justify-content-center p-0 xWBorder">
          <div class="col-10 text-center mx-auto">
              <h3 id="obhCancel" class="p-1 mb-1"><b><?php echo language('adawallet/main/main', 'tCancelTopupSuccess') ?></b></h3>
          </div>
      </div>

      <div class="row justify-content-center p-0 xWBorder" id="odvShowOtp">
        <div class="col-12 text-center mx-auto">
          <p id="obpCancelDetail" class="p-1 mb-0"></p>
          <p class="pt-0 pb-1 mb-0"><?php echo language('adawallet/main/main', 'tCancelTopupDetail') ?></p>
        </div>
      </div>

      <div class="row justify-content-center xWBorder">
        <div class="col-12 text-center">
          <p id="obpCancelInvoiceID" class="mb-4"></p>
        </div>
      </div>

      <div class="row justify-content-center xWBorder">
        <div class="col-8 xWBorder">
          <!-- <input type="submit" name="osmFinish" id="osmFinish" value="<?php echo language('adawallet/main/main', 'tFinish') ?>" class="btn xWBtnMain mx-auto" onclick="liff.closeWindow();"> -->
          <input type="submit" name="osmBack" id="osmBack" value="<?php echo language('adawallet/main/main', 'tBack') ?>" class="btn xWBtnMain mx-auto" onclick="location.reload();">
        </div>
      </div>

    </div>

    <!-- Modal -->
    <div class="modal fade" id="odvTopupConfirmModal" tabindex="-1" aria-labelledby="TopupConfirmModalLabel" aria-hidden="true">
      <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
          <div class="modal-header py-2 px-3 my-0">
            <h5 class="modal-title" id="TopupConfirmModalLabel"><?php echo language('adawallet/main/main', 'tConfirm') . language('adawallet/main/main', 'tProgram') . language('adawallet/main/main', 'tTopup') ?></h5>
            <button type="button" class="close" data-dismiss="modal" aria-label="Close">
              <span aria-hidden="true">&times;</span>
            </button>
          </div>
          <div class="modal-body">
            <p id="obpConfirmTopup" class="mb-0"></p>
          </div>
          <div class="modal-footer py-2 px-3 my-0">
            <div class="col text-right px-0 my-0">
              <input type="button" name="obtCancelTopup" id="obtCancelTopup" class="btn xWBtnCancelModal" data-dismiss="modal" value="<?php echo language('adawallet/main/main', 'tCancel') ?>"></input>
            </div>
            <div class="col-auto px-0 my-0">
              <input type="button" name="obtConfirmTopup" id="obtConfirmTopup" class="btn xWBtnMain" data-dismiss="modal" value="<?php echo language('adawallet/main/main', 'tConfirm') ?>"></input>
            </div>
          </div>
        </div>
      </div>
    </div>


    <!-- Include from the CDN -->
    <!-- <script src="https://cdn.jsdelivr.net/npm/html2canvas@1.0.0-rc.5/dist/html2canvas.min.js"></script> -->
    <script src="https://cdnjs.cloudflare.com/ajax/libs/html2canvas/1.3.4/html2canvas.min.js"></script>
    <script>
      document.getElementById('odvCheckbalance').style.display = "none";
      document.getElementById('odvTopup').style.display = "none";
      document.getElementById('odvGenqr').style.display = "none";
      document.getElementById('odvCancelTopup').style.display = "none";

      var tUserid = '';
      var tMoney = '';
      var nRandom = '';
      var nRandom2 = '';
      var tInvoiceID = '';
      var tDate = '';
      var nRef = '';
      var tBalance = '';
      var nDecimal = '';
      var xImage = '';

      async function JSaADWCheckBalance() {
        const profile = await liff.getProfile()
        tUserid = profile.userId;
        // tUserid = "Ua8123e603500c93fc05b40ae4fc5f58a";

        $.ajax({
          url: "<?php echo base_url('adwADWCheckBalance/') ?>",
          type: "POST",
          data: {
            "ptCstLineID": tUserid,
          },
          dataType: "json",
          cache: false,
          success: function(data) {
            document.getElementById('odvCheckbalance').style.display = "inline";
            document.getElementById('odvTopup').style.display = "inline";

            if(data['rtDesc'] == "Success") {

              console.log(data);
              nDecimal = data['pnDecimal'][0].FNShowDecimal;
              tBalance = data['roInfo']['rcCardTotal'].toFixed(nDecimal);

              document.getElementById('obpCardno').innerHTML = "<?php echo language('adawallet/main/main', 'tRefNo') ?>" + " : " + data['roInfo']['rtCrdCode']; 
              document.getElementById('obpCardtype').innerHTML = data['roInfo']['rtCtyName'];     
              document.getElementById('obpBalance').innerHTML = tBalance;    
              document.getElementById('obpNoti').style.display = "none";
              
            }else{
              document.getElementById('obpCardno').style.display = "none";
              document.getElementById('obpCardtype').style.display = "none";
              document.getElementById('obpBalance').style.display = "none";
              document.getElementById('obpBal').style.display = "none";
            }
          }
        });
      }

      async function main() {
        await liff.init({liffId: "1657332267-Wyargqr8", withLoginOnExternalBrower: true})
        if(liff.isLoggedIn()) {
          JSaADWCheckBalance()
        }else {
          liff.login();
        }
      }

      main()

      function JStADWMoney(money) {
        document.getElementById("onbMoney").value = money;
        document.getElementById("osmNext").disabled = false;
      }

      function JStCheckMoney() {
        if (document.getElementById("onbMoney").value == "" || document.getElementById("onbMoney").value <= "0") {
          document.getElementById("osmNext").disabled = true;
        }else{
          document.getElementById("osmNext").disabled = false;
        }
      }

      $(document).ready(function() {
        $('#osmNext').on('click', function(event) {
          if($('#ocbRequireDetailBank').prop('checked') == true && $('#ocbRequireDetailAmount').prop('checked') == true && $('#ocbRequireDetailQrcode').prop('checked') == true && $('#ocbRequireDetailExpire').prop('checked') == true){
            console.log("checked1")
            tMoney = parseInt(document.getElementById("onbMoney").value).toFixed(nDecimal);
            // tConfirmTopup = tMoney;
            document.getElementById('obpConfirmTopup').innerHTML = "<?php echo language('adawallet/main/main', 'tConfirm') . language('adawallet/main/main', 'tTopupTrans')?> " + tMoney + " <?php echo language('adawallet/main/main', 'tTHB')?>";
            document.getElementById('obtCancelTopup').value = "<?php echo language('adawallet/main/main', 'tCancel')?>";
            document.getElementById('obtConfirmTopup').style.display = "inline";
          }else {
            console.log("no checked1")
            document.getElementById('obpConfirmTopup').innerHTML = "<b><?php echo language('adawallet/main/main', 'tRequireTopup')?></b>";
            document.getElementById('obtCancelTopup').value = "<?php echo language('adawallet/main/main', 'tOK')?>";
            document.getElementById('obtConfirmTopup').style.display = "none";
          }
        
        });
        
        $('#obtConfirmTopup').on('click', function(event) {
          nRef = Math.floor(100000 + Math.random() * 900000);
          nRandom = Math.floor(100000000000 + Math.random() * 900000000000);
          nRandom2 = Math.floor(100000 + Math.random() * 900000);
          tInvoiceID = "S" + nRandom + "-" + nRandom2;

          // console.log( tInvoiceID, "/" , nRef);
          event.preventDefault();

          $.ajax({
            url: "<?php echo base_url('adwADWGenQR/') ?>",
            type: "POST",
            data: {
              "ptCstLineID": tUserid,
              "ptAmount": tMoney,
              "ptInvoiceID": tInvoiceID,
              "pnREF2": nRef
            },
            dataType: "json",
            cache: false,
            success: function(data) {
              if(data['Resp_Code'] == "00") {
                document.getElementById('odvCheckbalance').style.display = "none";
                document.getElementById('odvTopup').style.display = "none";
                document.getElementById('odvGenqr').style.display = "inline";

                
                document.getElementById("oimQR").src = 'data:image/png;base64,'+ data['QRStrImg'];
                document.getElementById('obhAmount').innerHTML = "<?php echo language('adawallet/main/main', 'tAmount') ?>" + " : " + tMoney;
                document.getElementById('obpInvoiceID').innerHTML = "<?php echo language('adawallet/main/main', 'tRefNo') ?>" + " : " + tInvoiceID;

                tDate = data['ptInvoiceDate']
                
                JStADWTopup();

              }
            }
          });
        });

        $('#osmCancel').on('click', function(event) {
          
          document.getElementById('odvGenqr').style.display = "none";
          document.getElementById('odvCancelTopup').style.display = "inline";
          document.getElementById('obpCancelDetail').innerHTML = "<?php echo language('adawallet/main/main', 'tTopupTrans') ?> " + tMoney + " <?php echo language('adawallet/main/main', 'tTHB') ?>";
          document.getElementById('obpCancelInvoiceID').innerHTML = "<?php echo language('adawallet/main/main', 'tRefNo') ?>" + " : " + tInvoiceID; 
          event.preventDefault();

        });
      });

      function JStADWTopup() {
        $.ajax({
          url: "<?php echo base_url('adwADWTopup/') ?>",
          type: "POST",
          data: {
            "ptCstLineID": tUserid,
            "ptAmount": tMoney,
            "ptInvoiceID": tInvoiceID,
            "ptInvoiceDate": tDate
          },
          dataType: "json",
          cache: false,
          success: function(data) {
            // console.log(data);
            if(data['rtDesc'] == 'success.') {
              // document.getElementById('obpTopupNoti').innerHTML = "<?php echo language('adawallet/main/main', 'tCapture') ?>";
            }
          }
        });
      }

      function JSxADWScreenshot() {
        let ocvQr = document.getElementById('odvQrCode');
  
        // Use the html2canvas
        // function to take a screenshot
        // and append it
        // to the output div
        html2canvas(ocvQr).then(
          function (canvas) {
            var tdataURL = canvas.toDataURL("image/jpeg");
            $.ajax({
              url: "<?php echo base_url('adwADWEventSaveImage/') ?>",
              type: "POST",
              data: {
                "ptCstLineID": tUserid,
                "ptAmount": tMoney,
                "ptInvoiceID": tInvoiceID,
                "ptDataURL": tdataURL
              },
              dataType: "json",
              cache: false,
              success: function(data) {
                console.log("success1");
                window.open('adwADWEventDonwloadImage/'+tMoney+'/'+tInvoiceID+'/?openExternalBrowser=1');
              }
            });
          })

      }

    </script>
  </body>

</html>