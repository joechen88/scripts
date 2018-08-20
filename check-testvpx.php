<!DOCTYPE HTML>  
<html>
<head>
<style>
.error {color: #FF0000;}
</style>
</head>
<body>  


<?php


$testvpxpath = "";


if ($_SERVER["REQUEST_METHOD"] == "POST") {
  if (empty($_POST["testvpxpath"])) {
    $testvpxpathErr = "Path is required";
  } else {
    // get the test vpx path input and store in $testvpxpath
    $testvpxpath = $_POST["testvpxpath"];
    
    // get the correlate testname
    $testname = getTestName("$testvpxpath");

    // need to strip out http://prme-vsanhol-nfs-vm2 or http://prme-vsanhol-observer-10
    $testvpxpath = stripTestPath("$testvpxpath");    
    $cmd = "logsummary.py -f {$testvpxpath} -t {$testname}"; 
    $output = shell_exec($cmd);
    echo "<pre>$output</pre>";
  }
}


function stripTestPath($tpathTMP) {

  #first strip out http://prme-vsanhol-nfs-vm2 or http://prme-vsanhol-observer-10.eng.vmware.com
  if (preg_match("/prme-vsanhol-observer-10/", $tpathTMP)){
       if (preg_match("/prme-vsanhol-observer-10.eng.vmware.com/", $tpathTMP)){
             $tpath = str_replace("http://prme-vsanhol-observer-10.eng.vmware.com","",$tpathTMP);
       } else {
             $tpath = str_replace("http://prme-vsanhol-observer-10","",$tpathTMP);
       }
  }
  elseif (preg_match("/prme-vsanhol-nfs-vm2/", $tpathTMP)){
       if (preg_match("/prme-vsanhol-nfs-vm2.eng.vmware.com/", $tpathTMP)){
             $tpath = str_replace("http://prme-vsanhol-nfs-vm2.eng.vmware.com","",$tpathTMP);
       } else {
             $tpath = str_replace("http://prme-vsanhol-nfs-vm2","",$tpathTMP);
       }
  }
  else {
       echo "Please only use link from prme-vsanhol-nfs-vm2 or prme-vsanhol-observer-10";
  }

  return $tpath;
}

function getTestName($tpath) {
 
  if (preg_match("/test-vpx.vsan.fvt.test.lsom.diskmanagement.diskRemoveReinsertPlanned_RAID1/", $tpath) ) {
	$testname = 'hp-planned';
  } 
  elseif (preg_match("/test-vpx.vsan.fvt.test.lsom.diskmanagement.diskRemoveReinsertPlanned_RAID1/", $tpath )) {
        $testname = 'hp-unplanned';
  }
  elseif (preg_match("/test-vpx.vsan.iocert.ctrl_combined_long/", $tpath) ) {
        $testname = 'combinedLong';
  }
  elseif (preg_match("/test-vpx.vsan.iocert.ctrlr_reset/", $tpath) ) {
        $testname = 'reset';
  }
  elseif (preg_match("/test-vpx.vsan.iocert.ctrlr_stress/", $tpath) ) {
        $testname = 'stress';
  }
  elseif (preg_match("/test-vpx.vsan.iocert.ctrlr_70r30w_long_99phr_enc/", $tpath) ) {
        $testname = 'hy-enc';
  }
  elseif (preg_match("/test-vpx.vsan.iocert.ctrlr_short_timeout_io/", $tpath) ) {
        $testname = 'shortio';
  }
  elseif (preg_match("/test-vpx.vsan.iocert.ctrlr_0r100w_long_4k_af/", $tpath) ) {
        $testname = '4k';
  }
  elseif (preg_match("/test-vpx.vsan.iocert.ctrlr_0r100w_long_64k_af/", $tpath) ) {
        $testname = '64';
  }
  elseif (preg_match("/test-vpx.vsan.iocert.ctrlr_100r0w_long_af/", $tpath) ) {
        $testname = 'af-100r0w';
  }
  elseif (preg_match("/test-vpx.vsan.iocert.ctrlr_70r30w_long_mdCap_af/", $tpath) ) {
        $testname = 'mdCap';
  }
  elseif (preg_match("/test-vpx.vsan.iocert.ctrlr_70r30w_long_50gb_af/", $tpath)) {
        $testname = '50gb';
  }
  elseif (preg_match("/test-vpx.vsan.iocert.ctrlr_sharedVmfs_boot_vsanDatastore_af/", $tpath) ) {
        $testname = 'sharedvmfs';
  }
  elseif (preg_match("/test-vpx.vsan.iocert.ctrlr_data_integrity_af/", $tpath) ) {
        $testname = 'af-data-integrity';
  }
  elseif (preg_match("/ctrlr_70r30w_long_mdCap_enc_af/", $tpath) ) {
        $testname = 'af-enc';
  }
  else {
	$testname = 'short';
  }

  return $testname;
}


?>

<form method="post" action="<?php echo htmlspecialchars($_SERVER["PHP_SELF"]);?>">  
  TestvpxPath: <input type="text" name="testvpxpath" size="180" value="<?php echo $testvpxpath;?>">
  <br><br>
  <input type="submit" name="submit" value="Submit">
</form>

</body>
</html>
