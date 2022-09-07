<html>

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title><?php echo language('adawallet/main/main', 'tPayment') . " " . language('adawallet/main/main', 'tAdw') ?></title>
    </head>

    <body>
        <div class="container mt-3 mb-2">
            <div class="row">
                <div class="col align-self-center xWMenu">  
                    <?php echo language('adawallet/main/main', 'tProgram') . " : " . language('adawallet/main/main', 'tPayment') . " " . language('adawallet/main/main', 'tAdw') ?>
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

        <div class="container" id="odvNotiGenqr">
            <p id="obpNoti"><?php echo language('adawallet/main/main', 'tNoti') ?></p>
        </div>

        <div class="container" id="odvGenqr">

            <div class="row justify-content-center mb-2 xWBorder" id="odvImgQR">
                <div class="col">
                    <img name="oimLine" id="oimLine" class="rounded mx-auto d-block" width="30px" style="position: relative; top:95px; display:none;">
                    <img name="oimQR" id="oimQR" class="rounded mx-auto d-block" src="<?php echo base_url().'/application/modules/adawallet/assets/images/qrcode_cap.png'?>">
                </div>
            </div>

            <div class="row justify-content-center xWBorder">
                <div class="col-10 text-center">
                    <h5 id="obhCardno" class="mb-0"></h5>
                </div>
            </div>
            
            <div class="row justify-content-center" id="odvOTPNoti">
                <div class="col-10 text-center">
                    <p id="obpPaymentNoti"><?php echo language('adawallet/main/main', 'tPaymentNoti') ?></p>
                </div>
            </div>
        </div>

        <div class="container mt-0" id="odvGenOtp">
            <div class="row justify-content-center xWBorder">
                <div class="col-10 text-center">
                    <h5 id="obhCardnoRef" class="mb-0"></h5>
                </div>
            </div>

            <div class="row justify-content-center xWBorder " id="odvShowOtp">
                <div class="col-10 text-center mx-auto">
                    <h3 id="obhOtp" class="mb-0"></h3>
                    <label class="mb-0" id="olaExpireNoti"><?php echo language('adawallet/main/main', 'tPlsWaitOTP') ?></label>
                    <p id="obpDateExp"></p>
                </div>
            </div>
        </div>


        <div class="container p-0" id="odvOTPRequest">
            <div class="row justify-content-center p-0 my-0" id="odvOTPRequest">
                <div class="col-10 text-center">
                    <?php echo language('adawallet/main/main', 'tOTPNoti') ?>
                    <b>
                        <a href="javascript:void(0);" class="xWOTP" onclick="JStRequestOTP();"><?php echo language('adawallet/main/main', 'tOTPClickhere') ?></a>
                    </b>
                </div>
            </div>
        </div>

        <div class="container p-0" id="odvOTPRequestAgain">
            <div class="row justify-content-center p-0 my-0" id="odvOTPRequest">
                <div class="col-10 text-center">
                    <?php echo language('adawallet/main/main', 'tNotRecOTP') ?> <br>
                    <b>
                        <a href="javascript:void(0);" class="xWOTP" onclick="JStRequestOTP();"><?php echo language('adawallet/main/main', 'tOTPClickhere') . " " . language('adawallet/main/main', 'tAgain') ?></a>
                    </b>
                </div>
            </div>
        </div>

        <div class="row justify-content-center xWBorder" id="odvOTPButton">
            <div class="col-10 mx-auto ">
                <input type="submit" name="osmFinish" id="osmFinish" value="<?php echo language('adawallet/main/main', 'tFinish') ?>" class="btn xWBtnMain mt-3 mx-auto" onclick="liff.closeWindow();">
            </div>
        </div>

        <script>
            document.getElementById('odvNotiGenqr').style.display = "none";
            document.getElementById('odvOTPRequest').style.display = "none";
            document.getElementById('odvOTPButton').style.display = "none";
            document.getElementById('odvOTPRequestAgain').style.display = "none";
            document.getElementById('odvGenOtp').style.display = "none";

            var tUserid = '';
            var tCardno = '';
            var tAgnCode = '';
            var tOTP = '';
            var tDate = '';

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
                        console.log(data);
                        if(data['rtDesc'] == "Success") {
                            tCardno = data['roInfo']['rtCrdCode'];
                            tAgnCode = data['roInfo']['rtAgnCode'];   
                            
                            document.getElementById('obhCardno').innerHTML = "<?php echo language('adawallet/main/main', 'tRefNo') ?>" + " : " + tCardno; 
                            document.getElementById('obhCardnoRef').innerHTML = "<?php echo language('adawallet/main/main', 'tRefNo') ?>" + " : " + tCardno; 
                            
                            JStADWGenQR();                   
                        }else{
                            document.getElementById('odvNotiGenqr').style.display = "inline";
                            document.getElementById('odvOTPButton').style.display = "inline";
                        }
                    }
                });
            }

            async function main() {
                await liff.init({liffId: "1657332267-Xp2E4kEv", withLoginOnExternalBrower: true})
                if(liff.isLoggedIn()) {
                    JSaADWCheckBalance()
                }else {
                    liff.login();
                }
            }

            main()
            
            function JStADWGenQR(){ 
                tValue = tCardno + ";" + tAgnCode;
                
                document.getElementById("oimQR").src = 'https://api.qrserver.com/v1/create-qr-code/?size=150x150&data='+tValue;
                setTimeout(function(){
                    document.getElementById("oimLine").src = "<?php echo base_url().'/application/modules/adawallet/assets/images/Line-Logo.png'?>";
                    document.getElementById('odvOTPRequest').style.display = "inline";
                    document.getElementById('odvOTPButton').style.display = "inline";
                },1000);
 
                
            }

            function JStRequestOTP() {
                document.getElementById('odvGenqr').style.display = "none";
                document.getElementById('odvGenOtp').style.display = "inline";
                
                document.getElementById('odvImgQR').style.display = "none";
                document.getElementById('odvOTPNoti').style.display = "none";
                document.getElementById('odvOTPRequest').style.display = "none";
                
                $.ajax({
                    url: "<?php echo base_url('adwADWRequestOTP/') ?>",
                    type: "POST",
                    data: {
                        "ptCrdCode": tCardno,
                        "ptCstLineID": tUserid,
                        "ptAgnCode": tAgnCode,
                    },
                    dataType: "json",
                    cache: false,
                    success: function(data) {
                        
                        console.log(data['ptStatus']);
                        if(data['ptStatus'] == "Success") {
                            tOTP = data['ptOTP'];
                            tDate = data['ptOTPExipred'];
                            
                        }else {
                            tOTP = "<?php echo language('adawallet/main/main', 'tReqAgain') ?>";
                            tDate = "";
                        }
                        
                        document.getElementById('obhOtp').innerHTML = tOTP;
                        document.getElementById('obpDateExp').innerHTML = tDate;
                        document.getElementById('olaExpireNoti').innerHTML = "<?php echo language('adawallet/main/main', 'tOTPExpireNoti') ?>";
                        document.getElementById('odvOTPRequestAgain').style.display = "inline";
                        
                    }
                });
            }

        </script>
    </body>

</html>