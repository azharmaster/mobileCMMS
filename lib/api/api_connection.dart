class API {
  static const hostConnect = 'http://192.168.0.119/pakar_api';
  static const hostImage = 'http://192.168.0.119/pakar_api';

  // login
  static const login = "$hostConnect/login.php";
   
  static const getScheduled = "$hostConnect/getScheduled.php";
  static const getUnscheduled = "$hostConnect/getUnscheduled.php";
  static const getRecentWork = "$hostConnect/getRecentWork.php";
  static const getAssetDetail = "$hostConnect/getAssetDetail.php"; 
  static const getAssets = "$hostConnect/getAssets.php";

    static const getDone = "$hostConnect/getDone.php";
  static const getDoneScheduled = "$hostConnect/getDoneScheduled.php";
  static const getDoneUnscheduled = "$hostConnect/getDoneUnscheduled.php";

  static const getImage = "$hostConnect/getImage.php";
  static const getQcCode = "$hostConnect/getQcCode.php";
  static const getCauseCode = "$hostConnect/getCauseCode.php";
  static const getUserInfo = "$hostConnect/getUserInfo.php";
  static const getAssigned = "$hostConnect/getAssigned.php";
  static const getTechs = "$hostConnect/getTechs.php";
  static const getNotification = "$hostConnect/getNotification.php";


  static const getAssetScheduled = "$hostConnect/getAssetScheduled.php";
  static const getAssetUnscheduled = "$hostConnect/getAssetUnscheduled.php";

// do maintenance
  static const mainScheduled = "$hostConnect/mainScheduled.php";
  static const mainUnscheduled = "$hostConnect/mainUnscheduled.php";


  static const doneMaintenance = '$hostConnect/doneMaintenance.php';
  static const getPendingSWO = '$hostConnect/getPendingSWO.php';

// Delete
  static const deleteRecent = '$hostConnect/deleteRecent.php';

// Update maintenance
  static const updateUnscheduled = '$hostConnect/updateUnscheduled.php';
  static const updateScheduled = '$hostConnect/updateScheduled.php';
  static const updateImage = '$hostConnect/updateImage.php';
  static const updateUserInfo = '$hostConnect/updateUserInfo.php';
  static const updateReadNoti = '$hostConnect/updateReadNoti.php';


  static const uploadImage = '$hostConnect/uploadImage.php';

} 