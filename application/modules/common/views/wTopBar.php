<style>
    #odvChangepasswordTopBar{
        padding: 10px 20px;
        cursor : pointer;
    }

    #odvChangepasswordTopBar:hover{
        background-color: #fafafa;
    }

    @media screen and (max-width: 767px){
        #odvChangepasswordTopBar{
            padding: 10px 15px !important;
        }
    }

    .xWImgPerson {
        width: 30px !important;
        height: 30px !important;
        border-radius: 50% !important;
        display: inline !important;
        margin-right: 5px !important;
        border: 1px solid #d8d8d8 !important;
    }

    .xWImgLogo {
        padding: 5px !important;
        width: auto !important;
        height: 50px !important;
        margin: -8px !important;
    }

/* Css Notification */
/* Create By witsarut 04/03/2020 */

    #odvCntMessage {
        display:block;
        position:absolute;
        background:#E1141E;
        color:#FFF;
        font-size:12px;
        font-weight:normal;
        padding:0px 6px;
        margin: 3px 0px 0px 18px;
        border-radius:2px;
        -moz-border-radius:2px; 
        -webkit-border-radius:2px;
        z-index:1;
    }

    #oliContainer {
        position:relative;
    }
   
    #odvNotiMessageAlert {
        display:none;
        width:380px;
        position:absolute;
        top:55px;
        left:-356px;
        background:#FFF;
        border:solid 1px rgba(100, 100, 100, .20);
        -webkit-box-shadow:0 3px 8px rgba(0, 0, 0, .20);
        z-index: 0;
    }

    #odvNotiMessageAlert:before {         
        content: '';
        display:block;
        width:0;
        height:0;
        color:transparent;
        border:10px solid #CCC;
        border-color:transparent transparent #f5f5f5;
        margin-top:-20px;
        margin-left:-800px;
    }
    .xCNShwAllMessage {
        background:#F6F7F8;
        padding:13px;
        font-size:12px;
        font-weight:bold;
        border-top:solid 1px rgba(100, 100, 100, .30);
        text-align:center;
    }

    .xCNShwAllMessage a {
        color:#3b5998;
    }

    .xCNShwAllMessage a:hover {
        background:#F6F7F8;
        color:#3b5998;
        text-decoration:underline;
    }

    .xCNMessageAlert {
        background      : #F6F7F8;
        font-weight     : bold;
        padding         : 15px;
        border          : 1px solid transparent;
        border-radius   : 4px;
    }

    .xCNBlockNoti{
        border      : 1px solid #dedede;
        background  : #fefefe;
        padding     : 10px;
        border-top  : 0px;
    }

</style>
<!-- WRAPPER -->
<div id="wrapper">
    <nav class="navbar navbar-default navbar-fixed-top" style="margin-left: 60px;">
        <div class="container-fluid">
            <div class="brand">
                <a href="<?php echo base_url();?>" >
                    <?php echo FCNtHGetImagePageList('','30px','logo','xWImgLogo'); ?>
                    <!-- <img id="oimCompanyImage" src="<?php echo base_url();?>application/modules/common/assets/images/logo/AdaPos5_Logo.png" alt="AdaFC Logo" class="img-responsive logo" style="padding:5px;width: auto;height: 50px;margin:-8px;"> -->
                </a>
                <a href="<?php echo base_url();?>" >
                    <div style="padding:5px;margin:-8px;position:absolute;top:25%;left:35%;margin-left:-100px;width:40%;text-align: center;"><span id="spnCompanyName"></span></div>
                </a>
            </div>
            <div id="navbar-menu">
                <ul class="nav navbar-nav navbar-right">
                    <li class="dropdown">
                        <?php FCNxHNotifications(); ?>
                        <?php echo FCNtHGetImagePageList($this->session->userdata('tSesUsrImagePerson'),'30px','user','xWImgPerson'); ?>
                        <?php /*if($this->session->userdata('tSesUsrImagePerson') == null){*/ ?>
                            <!-- ไม่มีภาพ -->
                            <!-- <?php $tPatchImg = base_url().'application/modules/common/assets/images/icons/Customer.png'; ?>
                            <img id="oimImgPerson" style="border: 0px !important;" class="img-responsive" src="<?php echo @$tPatchImg;?>"> -->
                        <?php 
                            // }else{
                            // $tImage = $this->session->userdata('tSesUsrImagePerson'); 
                            // $tImage = explode("application/modules",$tImage);
                            // $tPatchImg = base_url('application/modules/').$tImage[1];
                        ?>
                            <!-- <img id="oimImgPerson" class="img-responsive" src="<?=$tPatchImg?>">     -->
                        <?php /*}*/ ?>  
                        <button  class="dropdown-toggle" data-toggle="dropdown" style="color: white;margin-top: 10px;margin-right: 10px;"><a><span><?php echo $this->session->userdata('tSesUsrUsername') ?></span> <i class="icon-submenu lnr lnr-chevron-down"></i></a></button>
                        <ul class="dropdown-menu">
                            <li>
                                <a href="MyProfile">
                                    <i class="lnr lnr-user"></i> <span><?php echo language('common/main/main','tMNUProfile')?></span>
                                </a>
                            </li>
                            <li>
                                <div id="odvChangepasswordTopBar" onClick="JCNxCallModalChangePassword(1,<?php echo $this->session->userdata("tSesUsrInfo")['FTUsrLogType']; ?>);">
                                    <i class="lnr lnr-cog" style="vertical-align: middle;"></i>
                                    <span><?php echo language('common/main/main','tMNUChangePassword')?></span>
                                </div>
                            </li>
                            <li>
                                <a href="logout">
                                    <i class="lnr lnr-exit"></i> <span><?php echo language('common/main/main','tMNULogout')?></span>
                                </a>
                            </li>
                        </ul>
                    </li>
                </ul>
            </div>
        </div>
    </nav>
    <div id="odvNavibarClearfixed" style="background:#FFFFFF;z-index:500"></div>

 <script>
    $(document).ready(function(){

        JSxGetNameCompany();

        // ถ้าไม่มีรูปภาพอยู่ในโฟลเดอร์ ให้ใช้รูปภาพสแตนดาสของ AdaPos5 Logo
        // $('#oimCompanyImage').error(function() {
        //     var tLogoImage = "<?php echo base_url();?>"+"/application/modules/common/assets/images/logo/AdaPos5_Logo.png";
        //     var tLogoName  = "AdaFC Logo";
        //     $('#oimCompanyImage').attr('src',tLogoImage);
        //     $('#oimCompanyImage').attr('alt',tLogoName);
        // });

    });
    
    // call Company
    function JSxGetNameCompany(){
        $.ajax({
            type: "GET",
            url: "companyEventGetName",
            cache: false,
            timeout: 0,
            success: function(tResult) {
                var aReturn    = JSON.parse(tResult);
                var tLogoName  = aReturn['raItems']['FTLogoName'];
                var tLogoImage = aReturn['raItems']['FTLogoImage'];
                console.log(tLogoImage);
                if( tLogoImage != "NULL" && tLogoImage != null && tLogoImage != "" ){
                //     var aLogoImage = tLogoImage.split("/application");
                //     tLogoImage = "<?php echo base_url(); ?>" + "/application" + aLogoImage[1];
                    $('.xWImgLogo').attr('src',tLogoImage);
                    $('.xWImgLogo').attr('alt',tLogoName);
                }
                $('#spnCompanyName').html(tLogoName);
            },
            error: function(jqXHR, textStatus, errorThrown) {
                (jqXHR, textStatus, errorThrown);
            }
        });
    }

    $(document).ready(function(){

        //Event GetData Notification
        /*JSoGetDataNotification();
        numCount = 0;

        // *************** Connect RabbitMQ Notification ***************
        var tHost = "ws://" + oStatDoseSTOMMQConfig.host + ":15674/ws";
        var client = Stomp.client(tHost);

        var on_connect = function(x){
            client.subscribe('/exchange/CN_XNotiMsg<?=$this->session->userdata('tSesUsrBchCodeDefault')?>',function(res){ 
                //numCount++;
                var paData  = JSON.parse(res.body);
                
                $.ajax({
                    type        : "POST",
                    url         : "InsDataNotification",
                    dataType    : "json",
                    cache       : false,
                    data        : { tDataNoti : paData },
                    success: function (tResult){
                        var tFlagReturn = tResult.nStaEvent;

                        //ต้องเพิ่ม append เข้าไปใน List ใหม่
                        var aResult  = JSON.parse(res.body);
                        var nCount   = aResult.ptData.paContents.length;
                        numCount     = numCount + nCount;
                        $('#odvCntMessage').text(numCount);
                        $('#odvCntMessage').css('display','block');

                        if($('#odvNotiMessageAlert').css('display') != 'none'){ 
                            var tClassWillRemove = 'xCNWillingRemove';
                        }else{
                            var tClassWillRemove = '';
                        }
                        
                        for($i=0; $i<nCount; $i++){
                            var aSubProduct = aResult.ptData.paContents[$i];
                            var tTopic      = aResult.ptData.ptFTTopic;
                            var tDataTime   = aResult.ptData.ptFDSendDate;
                            var tWah        = aSubProduct.ptFTSubTopic;
                            var tMsg        = aSubProduct.ptFTMsg;

                            var tHTML = "<div class='xCNBlockNoti "+tClassWillRemove+"'>";
                                tHTML += "<label style='font-weight: bold; font-style: italic;'>"+tTopic+"</label><label>" + '&nbsp; (' + tDataTime + ')' + "</label>";
                                tHTML += "<p>คลังสินค้า : "+tWah+"</p>";
                                tHTML += "<p>ข้อความ : "+tMsg+"</p>";
                                tHTML += "</div>";

                            $('#odvMessageShow').prepend(tHTML);
                        }
                    },
                    error: function (data) {
                        console.log(data);
                    }
                });
            });
        }

        var on_error = function(x) {
            console.log(x);
        }
        client.connect(oStatDoseSTOMMQConfig.user, oStatDoseSTOMMQConfig.password, on_connect, on_error, oStatDoseSTOMMQConfig.vhost_notification);

        // *************** Connect RabbitMQ Notification ***************

        $('#obtNotibtn').click(function () {
            $('#odvNotiMessageAlert').fadeToggle('fast', 'linear', function () {
                if ($('#odvNotiMessageAlert').is(':hidden')) {
                }
            });
            $('#odvCntMessage').fadeOut('slow');  
                return false;
        });

        $(document).click(function () {
            $('#odvNotiMessageAlert').hide();
            if ($('#odvCntMessage').is(':hidden')) {
            }
        });

        $('#odvNotiMessageAlert').click(function () {
            return false;
        });*/
    });
</script>
<?php include('application/modules/common/views/script/jChangePassword.php'); ?>