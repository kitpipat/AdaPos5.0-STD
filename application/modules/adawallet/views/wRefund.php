<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title><?php echo language('adawallet/main/main', 'tRefund') . " " . language('adawallet/main/main', 'tAdw') ?></title>
    </head>

    <body>
        <div class="container mt-3 mb-2">
            <div class="row">
            <div class="col align-self-center xWMenu">
                <?php echo language('adawallet/main/main', 'tProgram') . " : " . language('adawallet/main/main', 'tRefund') . " " . language('adawallet/main/main', 'tAdw') ?>
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

        <div class="container" id="odvCheck">
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
                            <div class="row align-items-center justify-content-between">
                                <div class="col-auto align-bottom">
                                    <p id="obpCardno" class="card-subtitle my-1 text-muted"><?php echo language('adawallet/main/main', 'tRefNo') ?></p>
                                </div>
                                <div class="col-auto "> 
                                    <p id="obpBal" class="card-subtitle my-1 text-muted"><?php echo language('adawallet/main/main', 'tBalance') ?> (<?php echo language('adawallet/main/main', 'tTHB') ?>) </p>
                                </div>
                            </div>
                            <h3 id="obpBalance" class="card-text text-right"></h3>
                        </div>
                    </div>
                </div>
            </div>
            <!-- end เช็คยอดเงิน -->

            <!-- ธนาคาร -->
            <div id="odvBank">
                <div class="row my-2 mx-1 p-0">
                    <p class="mb-0"><b><?php echo language('adawallet/main/main', 'tRefundBank') ?></b></p>
                </div>

                <!-- เลือกจำนวนธนาคารและกรอกเลขที่บัญชี -->
                <div class="row justify-content-center my-2 mx-1 p-0">
                    <div class="col mx-1 p-0">
                        <select name="ocmBank" id="ocmBank" class="custom-select xWInput mb-1" aria-label="Default select example">
                            <option value="SCB"><?php echo language('adawallet/main/main', 'tSCB') ?></option>
                            <option value="KTB"><?php echo language('adawallet/main/main', 'tKTB') ?></option>
                            <option value="KBANK"><?php echo language('adawallet/main/main', 'tKBANK') ?></option>
                            <option value="BBL"><?php echo language('adawallet/main/main', 'tBBL') ?></option>
                            <option value="GSB"><?php echo language('adawallet/main/main', 'tGSB') ?></option>
                            <option value="TTB"><?php echo language('adawallet/main/main', 'tTTB') ?></option>
                            <option value="BAY"><?php echo language('adawallet/main/main', 'tBAY') ?></option>
                        </select>
                    </div>
                </div>

                <div class="row my-2 mx-1 p-0">
                    <p class="mb-0"><b><?php echo language('adawallet/main/main', 'tRefundAccountNo') ?></b></p>
                </div>

                <div class="row justify-content-center mt-2 mx-1 p-0">
                    <div class="col my-0 mx-1 p-0">
                        <input type="text" class="form-control mt-0 mb-1 xWInput" name="oetAccount" id="oetAccount" placeholder="0" onkeyup="JSxCheckAccount();">
                    </div>
                </div>
                <!-- end เลือกจำนวนธนาคารและกรอกเลขที่บัญชี -->

                <!-- เงื่อนไขการคืนเงิน -->
                <div class="row my-2 mx-1 p-0">
                    <div class="col mx-1 p-0">
                        <p class="mb-0"><b><?php echo language('adawallet/main/main', 'tRequireRefund') ?></b></p>
                    </div>
                </div>

                <div class="row mx-1 p-0">
                    <div class="col mx-1 p-1">
                        <div class="form-check mx-2">
                        <input class="form-check-input xWCheckbox" type="checkbox" id="ocbRequireRefundOnlyAccountNo" value="<?php echo language('adawallet/main/main', 'tRequireRefundOnlyAccountNo') ?>">
                        <label class="form-check-label" for="ocbRequireRefundOnlyAccountNo"><p class="text-justify mb-0"><?php echo language('adawallet/main/main', 'tRequireRefundOnlyAccountNo') ?></p></label>
                        </div>
                    </div>
                </div>

                <div class="row mx-1 p-0">
                    <div class="col mx-1 p-1">
                        <div class="form-check mx-2">
                        <input class="form-check-input xWCheckbox" type="checkbox" id="ocbRequireRefundBalance" value="<?php echo language('adawallet/main/main', 'tRequireRefundBalance') ?>">
                        <label class="form-check-label" for="ocbRequireRefundBalance"><p class="text-justify mb-0"><?php echo language('adawallet/main/main', 'tRequireRefundBalance') ?></p></label>
                        </div>
                    </div>
                </div>
                    
                <div class="row mx-1 p-0">
                    <div class="col mx-1 p-1">
                        <div class="form-check mx-2">
                        <input class="form-check-input xWCheckbox" type="checkbox" id="ocbRequireRefundDetail" value="<?php echo language('adawallet/main/main', 'tRequireRefundDetail') ?>">
                        <label class="form-check-label" for="ocbRequireRefundDetail"><p class="text-justify mb-0"><?php echo language('adawallet/main/main', 'tRequireRefundDetail') ?></p></label>
                        </div>
                    </div>
                </div>
            </div>
                <!-- end เงื่อนไขการคืนเงิน -->

                <div class="row my-2 mx-1 p-0">
                    <input type="submit" class="btn xWBtnMain mb-3" name="osmConfirm" id="osmConfirm" data-toggle="modal" data-target="#odvRefundConfirmModal" value="<?php echo language('adawallet/main/main', 'tConfirmRefund') ?>" disabled>
                </div>
            </div>
            <!-- end ธนาคาร -->
        </div>

        <!-- ผลลัพธ์หลังกดคืนเงิน -->
        <div class="container" id="odvResult">
            <div class="row justify-content-center">
                <div class="col-10 text-center">
                    <h2 id="obhResult" class="mb-1"><?php echo language('adawallet/main/main', 'tRefundSuccess') ?></h2>
                    <label id="obpNotiResult"><b><?php echo language('adawallet/main/main', 'tRequireRefundDetail') ?></b></label>
                    <br>
                    <label id="obpCardResult"><?php echo language('adawallet/main/main', 'tRefNo') ?> : </label>
                </div>
            </div>
            <div class="row justify-content-center">
                <div class="col-8">
                    <input type="submit" name="osmFinish" id="osmFinish" value="<?php echo language('adawallet/main/main', 'tFinish') ?> " class="btn xWBtnMain mt-2 mx-auto" onclick="liff.closeWindow();">
                </div>
            </div>
        </div>
        <!-- end ผลลัพธ์หลังกดคืนเงิน -->

        <!-- Modal -->
        <div class="modal fade" id="odvRefundConfirmModal" tabindex="-1" aria-labelledby="RefundConfirmModalLabel" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content">
                <div class="modal-header py-2 px-3 my-0">
                    <h5 class="modal-title" id="RefundConfirmModalLabel"><?php echo language('adawallet/main/main', 'tConfirm') . language('adawallet/main/main', 'tProgram') . language('adawallet/main/main', 'tRefund') ?></h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <p id="obpConfirmRefund" class="mb-0"></p>
                    <p id="obpConfirmRefundBank" class="mb-0"></p>
                    <p id="obpConfirmRefundAccountNo" class="mb-0"></p>
                </div>
                <div class="modal-footer py-2 px-3 my-0">
                    <div class="col text-right px-0 my-0">
                    <input type="button" name="obtCancelRefund" id="obtCancelRefund" class="btn xWBtnCancelModal" data-dismiss="modal" value="<?php echo language('adawallet/main/main', 'tCancel') ?>"></input>
                    </div>
                    <div class="col-auto px-0 my-0">
                    <input type="button" name="obtConfirmRefund" id="obtConfirmRefund" class="btn xWBtnMain" data-dismiss="modal" value="<?php echo language('adawallet/main/main', 'tConfirm') ?>"></input>
                    </div>
                </div>
                </div>
            </div>
        </div>
        <!-- end Modal -->

        <script>

            document.getElementById('odvCheckbalance').style.display = "none";
            document.getElementById('odvBank').style.display = "none";          
            document.getElementById('odvResult').style.display = "none";
            document.getElementById('osmConfirm').style.display = "none";

            var tUserid = '';
            var tBalance = '';
            var tRandom = '';
            var tRandom2 = '';
            var tInvoiceID = '';
            var tBankIndex = '';
            var tBank = '';
            var tAccountNo = '';
            var nDecimal = '';

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

                        document.getElementById('odvCheckbalance').style.display = "inline";
                        document.getElementById('odvBank').style.display = "inline";
                        document.getElementById('osmConfirm').style.display = "inline";
                        // console.log(data)
                        if(data['rtDesc'] == "Success") {
                            console.log(data);
                            nDecimal = data['pnDecimal'][0].FNShowDecimal;
                            tBalance = data['roInfo']['rcCardTotal'].toFixed(nDecimal);

                            if(data['rtCode'] == "04"){
                                document.getElementById('obpNoti').innerHTML = "<b><?php echo language('adawallet/main/main', 'tNotRegis') . " " . language('adawallet/main/main', 'tPleaseRegis')?></b>"; 
                                document.getElementById('obpCardno').style.display = "none";
                                document.getElementById('obpCardtype').style.display = "none";
                                document.getElementById('obpBalance').style.display = "none";
                                document.getElementById('obpBal').style.display = "none";     
                                $("#odvBank *").attr("disabled", "disabled").off('click');
                            }else{
                                tBalance = data['roInfo']['rcCardTotal'].toFixed(nDecimal);
                                
                                document.getElementById('obpCardno').innerHTML = "<?php echo language('adawallet/main/main', 'tRefNo') ?>" + " : " + data['roInfo']['rtCrdCode']; 
                                document.getElementById('obpCardtype').innerHTML = data['roInfo']['rtCtyName'];
                                document.getElementById('obpBalance').innerHTML = tBalance;    
                                
                                document.getElementById('obpCardResult').innerHTML =  data['roInfo']['rtCtyName'] + " : " + "<?php echo language('adawallet/main/main', 'tRefNo') ?>" + " " + data['roInfo']['rtCrdCode']; 

                                if(data['rtCode'] == "05") {
                                    document.getElementById('obpNoti').style.display = "inline";
                                    document.getElementById('obpNoti').innerHTML = "<b><?php echo language('adawallet/main/main', 'tCardExpire') . " " . language('adawallet/main/main', 'tRegisAgain')?></b>"; 
                                    $("#odvBank *").attr("disabled", "disabled").off('click');
                                }else{
                                    document.getElementById('obpNoti').style.display = "none";
                                }
                            }
                            
                        }else{
                            document.getElementById('obpCardno').style.display = "none";
                            document.getElementById('obpCardtype').style.display = "none";
                            document.getElementById('obpBalance').style.display = "none";
                            document.getElementById('obpBal').style.display = "none";  
                            $("#odvBank *").attr("disabled", "disabled").off('click');                         
                        }
                    }
                });
            }

            async function main() {
                // await liff.init({liffId: "1657332267-K55Av9A4", withLoginOnExternalBrower: true})
                await liff.init({liffId: "1657787973-qogWBzNn", withLoginOnExternalBrower: true})
                if(liff.isLoggedIn()) {
                    JSaADWCheckBalance()
                }else {
                    liff.login();
                }
            }

            main()

            function JSxCheckAccount() {
                if (document.getElementById("oetAccount").value == "") {
                    document.getElementById("osmConfirm").disabled = true;
                }else{
                    document.getElementById("osmConfirm").disabled = false;
                }
            }

            $(document).ready(function() {
                $('#osmConfirm').on('click', function(event) {
                    if($('#ocbRequireRefundOnlyAccountNo').prop('checked') == true && $('#ocbRequireRefundBalance').prop('checked') == true && $('#ocbRequireRefundDetail').prop('checked') == true){

                        tBankIndex = document.getElementById("ocmBank");
                        tBank = tBankIndex.options[tBankIndex.selectedIndex].value;
                        tAccountNo = document.getElementById("oetAccount").value;

                        document.getElementById('obtConfirmRefund').style.display = "inline";
                        document.getElementById('obpConfirmRefund').innerHTML = "<?php echo language('adawallet/main/main', 'tConfirm') . language('adawallet/main/main', 'tRefundTrans')?> " + tBalance + " <?php echo language('adawallet/main/main', 'tTHB')?>";
                        document.getElementById('obpConfirmRefundBank').innerHTML = "<?php echo language('adawallet/main/main', 'tRefundAccountNo')?> : " + tAccountNo;
                        document.getElementById('obpConfirmRefundAccountNo').innerHTML = "<?php echo language('adawallet/main/main', 'tRefundBank')?> : " + tBank;
                        document.getElementById('obtCancelRefund').value = "<?php echo language('adawallet/main/main', 'tCancel')?>";
                    }else {
                        // console.log("no checked1")
                        document.getElementById('obpConfirmRefund').innerHTML = "<b><?php echo language('adawallet/main/main', 'tRequireRefund')?></b>";
                        document.getElementById('obtCancelRefund').value = "<?php echo language('adawallet/main/main', 'tOK')?>";
                        document.getElementById('obtConfirmRefund').style.display = "none";
                    }
                });

                $('#obtConfirmRefund').on('click', function(event) {
                    tRandom = Math.floor(100000000000 + Math.random() * 900000000000);
                    tRandom2 = Math.floor(100000 + Math.random() * 900000);
                    tInvoiceID = "S" + tRandom + "-" + tRandom2;


                    console.log( tBank, tAccountNo);
                    event.preventDefault();

                    $.ajax({
                        url: "<?php echo base_url('adwADWEventRefund/') ?>",
                        type: "POST",
                        data: {
                            "ptCstLineID": tUserid,
                            "ptAmount": tBalance,
                            "ptInvoiceID": tInvoiceID,
                            "ptBankCode": tBank,
                            "ptBankAccount": tAccountNo
                        },
                        dataType: "json",
                        cache: false,
                        success: function(data) {
                            document.getElementById('odvCheckbalance').style.display = "none";
                            document.getElementById('odvBank').style.display = "none";
                            document.getElementById('osmConfirm').style.display = "none";
                            document.getElementById('odvResult').style.display = "inline";
                        }
                    });
                });
            });
        </script>
    </body>

</html>