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

        <!-- แจ้งเตือนกรณี gen qr code ไม่ได้ -->
        <div class="container" id="odvNotiGenqr">
            <div class="row justify-content-center">
                <div class="col-10 mx-auto text-center">
                    <p id="obpNoti"><b><?php echo language('adawallet/main/main', 'tNoti') ?></b></p>
                </div>
            </div>
        </div>
        <!-- end แจ้งเตือนกรณี gen qr code ไม่ได้ -->

        <!-- แจ้งเตือนกรณี บัตรหมดอายุ -->
        <div class="container pb-0" id="odvCardExpire">
            <div class="row justify-content-center">
                <div class="col-10 mx-auto text-center">
                    <h2 id="obhResult" class="mb-1"><?php echo language('adawallet/main/main', 'tCardExpire') . " " . language('adawallet/main/main', 'tRegisAgain')?></h2>
                </div>
            </div>
        </div>
        <!-- end แจ้งเตือนกรณี บัตรหมดอายุ -->

        <!-- แสดง qr code -->
        <div class="container" id="odvGenqr">

            <div class="row justify-content-center mb-2 xWBorder" id="odvImgQR">
                <div class="col">
                    <!-- <img name="oimLine" id="oimLine" class="rounded mx-auto d-block" width="30px" style="position: relative; top:95px; display:none;"> -->
                    <img name="oimQR" id="oimQR" class="rounded mx-auto d-block" src="<?php echo base_url().'/application/modules/adawallet/assets/images/qrcode_payment.png'?>">
                    <canvas id="ocvPayment" class="rounded mx-auto d-block" ></canvas>
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
        <!-- end แสดง qr code -->

        <!-- แสดง otp -->
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
        <!-- end แสดง otp -->

        <!-- ขอ otp -->
        <div class="container p-0" id="odvOTPRequest">
            <div class="row justify-content-center p-0 my-0" id="odvOTPRequest">
                <div class="col-10 text-center mt-3">
                    <?php echo language('adawallet/main/main', 'tOTPNoti') ?>
                    <b>
                        <a href="javascript:void(0);" class="xWOTP" onclick="JStRequestOTP();"><?php echo language('adawallet/main/main', 'tOTPClickhere') ?></a>
                    </b>
                </div>
            </div>
        </div>
        <!-- end ขอ otp -->

        <!-- ขอ otp อีกครั้ง -->
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
        <!-- end ขอ otp อีกครั้ง -->

        <div class="row justify-content-center xWBorder" id="odvOTPButton">
            <div class="col-10 mx-auto ">
                <input type="submit" name="osmFinish" id="osmFinish" value="<?php echo language('adawallet/main/main', 'tFinish') ?>" class="btn xWBtnMain mt-3 mx-auto" onclick="liff.closeWindow();">
            </div>
        </div>

        <script type="text/javascript">
            document.getElementById('odvNotiGenqr').style.display = "none";
            document.getElementById('odvOTPRequest').style.display = "none";
            document.getElementById('odvOTPButton').style.display = "none";
            document.getElementById('odvOTPRequestAgain').style.display = "none";
            document.getElementById('odvGenOtp').style.display = "none";
            document.getElementById('odvCardExpire').style.display = "none";
            document.getElementById('obpPaymentNoti').style.display = "none";

            var tUserid = '';
            var tCardno = '';
            var tAgnCode = '';
            var tOTP = '';
            var tDate = '';

            async function JSaADWCheckBalance() {
                const profile = await liff.getProfile()
                tUserid = profile.userId;
                
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
                            if(data['rtCode'] == "04") {
                                document.getElementById('odvNotiGenqr').style.display = "inline";
                                document.getElementById('odvOTPButton').style.display = "inline";
                            }else {
                                tCardno = data['roInfo']['rtCrdCode'];
                                tAgnCode = data['roInfo']['rtAgnCode'];   
                                
                                document.getElementById('obhCardno').innerHTML = "<?php echo language('adawallet/main/main', 'tRefNo') ?>" + " : " + tCardno; 
                                document.getElementById('obhCardnoRef').innerHTML = "<?php echo language('adawallet/main/main', 'tRefNo') ?>" + " : " + tCardno; 
                                if(data['rtCode'] == "05") {
                                    document.getElementById('odvCardExpire').style.display = "inline";
                                    document.getElementById('odvImgQR').style.display = "none";
                                    document.getElementById('odvOTPNoti').style.display = "none";
                                    document.getElementById('odvOTPButton').style.display = "inline";
                                }else{
                                    document.getElementById('odvCardExpire').style.display = "none";
                                    
                                    JStADWGenQR();                   
                                }
                            }
                                
                        }else{
                            document.getElementById('odvNotiGenqr').style.display = "inline";
                            document.getElementById('odvOTPButton').style.display = "inline";
                        }
                    }
                });
            }

            async function main() {
                // await liff.init({liffId: "1657332267-Xp2E4kEv", withLoginOnExternalBrower: true})
                await liff.init({liffId: "1657787973-3QP4oKOb", withLoginOnExternalBrower: true})
                if(liff.isLoggedIn()) {
                    JSaADWCheckBalance()
                }else {
                    liff.login();
                }
            }

            main()
            
            function JStADWGenQR(){ 
                tValue = tCardno + ";" + tAgnCode;

                tdata = tValue;
                tsize = '170x170';
                tlogo =  "<?php echo base_url().'/application/modules/adawallet/assets/images/LineWallet.png'?>";

                const xelement = document.getElementById("oimQR");
                xelement.remove();

                var xcanvas = document.getElementById('ocvPayment');
                var xcontext = xcanvas.getContext('2d');
                var xImgQR = new Image();
                var xImgLogo = new Image();

                xImgQR.onload = function() {
                    xcanvas.width = xImgQR.width;
                    xcanvas.height = xImgQR.height;
                    xImgLogo.src = tlogo;
                };
                xImgLogo.onload = function() {
                    xcontext.globalAlpha = 1.0;
                    xcontext.drawImage(xImgQR, 0, 0);
                    xcontext.globalAlpha = 1.0; //Remove if pngs have alpha
                    xcontext.drawImage(xImgLogo, 69, 69);
                };        
                
                xImgQR.src = 'https://chart.googleapis.com/chart?cht=qr&chld=H|1&chs='+tsize+'&chl='+(tdata);
                document.getElementById('odvOTPRequest').style.display = "inline";
                document.getElementById('odvOTPButton').style.display = "inline";
                document.getElementById('obpPaymentNoti').style.display = "inline";

            }

            function JStRequestOTP() {
                document.getElementById('odvGenqr').style.display = "none";
                document.getElementById('odvGenOtp').style.display = "inline";
                
                document.getElementById('odvImgQR').style.display = "none";
                document.getElementById('odvOTPNoti').style.display = "none";
                document.getElementById('odvOTPRequest').style.display = "none";
                document.getElementById('odvCardExpire').style.display = "none";
                
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
                        
                        // document.getElementById('odvCardExpire').style.display = "none";
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