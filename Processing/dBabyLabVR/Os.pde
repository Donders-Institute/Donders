  private static String OS = System.getProperty("os.name").toLowerCase();

  int flag_os =0;
  
  void ini_os()
  {
                  if (isWindows()) {
                      flag_os =1;
                  } else if (isMac()) {
                       flag_os =2;

                  } else if (isUnix()) {
                       flag_os =3;
                  } else if (isSolaris()) {
                       flag_os =4;
                  } else {
                    System.out.println("Your OS is not support!!");
                    exit();
                  }  
  
  }
  
  
  
  public static boolean isWindows() {

    return (OS.indexOf("win") >= 0);

  }

  public static boolean isMac() {

    return (OS.indexOf("mac") >= 0);

  }

  public static boolean isUnix() {

    return (OS.indexOf("nix") >= 0 || OS.indexOf("nux") >= 0 || OS.indexOf("aix") > 0 );
    
  }

  public static boolean isSolaris() {

    return (OS.indexOf("sunos") >= 0);

  }
