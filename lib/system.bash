# Set of constants for identifying different Operating  Systems
BC_SYSTEM_PLATFORM_MACOSX='Mac OSX X'
BC_SYSTEM_PLATFORM_LINUX='Linux'
BC_SYSTEM_PLATFORM_WINDOWS='MS Windows'
BC_SYSTEM_PLATFORM_UNKNOWN='Unknown'

# Identifies the running platform as one of the constants
# identified with the prefix BC_SYSTEM_PLATFORM_, where the suffix
# can be:
#
# 1. MACOSX
# 2. LINUX
# 3. WINDOWS
# 4. UNKNOWN
#
# In case of 'Unknown', return a status code of 1
system.platform() {
  case "$(uname -s)" in
    Darwin)
      echo "$BC_SYSTEM_PLATFORM_MACOSX"
      ;;
    Linux)
      echo "$BC_SYSTEM_PLATFORM_LINUX"
      ;;
    CYGWIN*|MINGW32*|MSYS*|MINGW*)
      echo "$BC_SYSTEM_PLATFORM_WINDOWS"
      ;;
    *)
      echo "$BC_SYSTEM_PLATFORM_UNKNOWN"
      return 1
      ;;
  esac
  return 0
}

# Gets the number of available cores for the system,
# and sends them to STDOUT.
system.processor_count() {
  getconf _NPROCESSORS_ONLN
}
