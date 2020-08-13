Return-Path: <prvs=487b39e6c=shinichiro.kawasaki@wdc.com>
From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH 4/6] t/zbd: Add -o option to t/zbd/test-zoned-support
Date: Thu, 13 Aug 2020 13:57:22 +0900
Message-Id: <20200813045724.47475-5-shinichiro.kawasaki@wdc.com>
In-Reply-To: <20200813045724.47475-1-shinichiro.kawasaki@wdc.com>
References: <20200813045724.47475-1-shinichiro.kawasaki@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: Damien Le Moal <Damien.LeMoal@wdc.com>, Dmitry Fomichev <Dmitry.Fomichev@wdc.com>, Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
List-ID: <fio@vger.kernel.org>

To specify maximum open zones of the test target device, add -o option
to t/zbd/test-zoned-support. When this option is specified, add
max_open_zones option to all fio commands in the test script. The option
ensures the number of zones opened by fio is within the limit. This is
useful when the test target device has maximum open zones limit.

When the fio command does not have multiple jobs and the test case does
not specify max_open_zones, add single max_open_zones option to the fio
command line.

When the fio command takes multiple jobs, add max_open_zones option to
each job. Introduce job_var_opts variable to keep options to be added to
each job. To distinguish it from global options for all jobs, rename
var_opts variable to global_var_opts. When a test case with multiple jobs
always specifies max_open_zones option, exclude the max_open_zones option
from job_var_opts, using job_var_opts_exclude() helper function.

Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
---
 t/zbd/test-zbd-support | 70 ++++++++++++++++++++++++++++++++++--------
 1 file changed, 57 insertions(+), 13 deletions(-)

diff --git a/t/zbd/test-zbd-support b/t/zbd/test-zbd-support
index 9e398cab..c21d6aad 100755
--- a/t/zbd/test-zbd-support
+++ b/t/zbd/test-zbd-support
@@ -12,6 +12,7 @@ usage() {
 	echo -e "\t-v Run fio with valgrind --read-var-info option"
 	echo -e "\t-l Test with libzbc ioengine"
 	echo -e "\t-r Reset all zones before test start"
+	echo -e "\t-o <max_open_zones> Run fio with max_open_zones limit"
 	echo -e "\t-t <test #> Run only a single test case with specified number"
 	echo -e "\t-z Run fio with debug=zbd option"
 }
@@ -103,14 +104,41 @@ is_scsi_device() {
     return 1
 }
 
+job_var_opts_exclude() {
+	local o
+	local ex_key="${1}"
+
+	for o in "${job_var_opts[@]}"; do
+		if [[ ${o} =~ "${ex_key}" ]]; then
+			continue
+		fi
+		echo -n "${o}"
+	done
+}
+
+has_max_open_zones() {
+	while (($# > 1)); do
+		if [[ ${1} =~ "--max_open_zones" ]]; then
+			return 0
+		fi
+		shift
+	done
+	return 1
+}
+
 run_fio() {
     local fio opts
 
     fio=$(dirname "$0")/../../fio
 
-    opts=("--max-jobs=16" "--aux-path=/tmp" "--allow_file_create=0" \
-	  "--significant_figures=10" "$@")
-    opts+=(${var_opts[@]})
+    opts=(${global_var_opts[@]})
+    opts+=("--max-jobs=16" "--aux-path=/tmp" "--allow_file_create=0" \
+			   "--significant_figures=10" "$@")
+    # When max_open_zones option is specified to this test script, add
+    # max_open_zones option to fio command unless the test case already add it.
+    if [[ -n ${max_open_zones_opt} ]] && ! has_max_open_zones "${opts[@]}"; then
+	    opts+=("--max_open_zones=${max_open_zones_opt}")
+    fi
     { echo; echo "fio ${opts[*]}"; echo; } >>"${logfile}.${test_number}"
 
     "${dynamic_analyzer[@]}" "$fio" "${opts[@]}"
@@ -128,13 +156,16 @@ write_and_run_one_fio_job() {
     local r
     local write_offset="${1}"
     local write_size="${2}"
+    local -a write_opts
 
     shift 2
     r=$(((RANDOM << 16) | RANDOM))
-    run_fio --filename="$dev" --randseed="$r"  --name="write_job" --rw=write \
-	    "$(ioengine "psync")" --bs="${logical_block_size}" \
-	    --zonemode=zbd --zonesize="${zone_size}" --thread=1 --direct=1 \
-	    --offset="${write_offset}" --size="${write_size}" \
+    write_opts=(--name="write_job" --rw=write "$(ioengine "psync")" \
+		      --bs="${logical_block_size}" --zonemode=zbd \
+		      --zonesize="${zone_size}" --thread=1 --direct=1 \
+		      --offset="${write_offset}" --size="${write_size}")
+    write_opts+=("${job_var_opts[@]}")
+    run_fio --filename="$dev" --randseed="$r" "${write_opts[@]}" \
 	    --name="$dev" --wait_for="write_job" "$@" --thread=1 --direct=1
 }
 
@@ -512,7 +543,7 @@ test25() {
 	opts+=("--offset=$((first_sequential_zone_sector*512 + zone_size*i))")
 	opts+=("--size=$zone_size" "$(ioengine "psync")" "--rw=write" "--bs=16K")
 	opts+=("--zonemode=zbd" "--zonesize=${zone_size}" "--group_reporting=1")
-	opts+=(${var_opts[@]})
+	opts+=(${job_var_opts[@]})
     done
     run_fio "${opts[@]}" >> "${logfile}.${test_number}" 2>&1 || return $?
 }
@@ -557,7 +588,7 @@ test28() {
 	opts+=("--size=$zone_size" "--io_size=$capacity" "$(ioengine "psync")" "--rw=randwrite")
 	opts+=("--thread=1" "--direct=1" "--zonemode=zbd")
 	opts+=("--zonesize=${zone_size}" "--group_reporting=1")
-	opts+=(${var_opts[@]})
+	opts+=(${job_var_opts[@]})
     done
     run_fio "${opts[@]}" >> "${logfile}.${test_number}" 2>&1 || return $?
     check_written $((jobs * $capacity)) || return $?
@@ -581,7 +612,8 @@ test29() {
 	opts+=("$(ioengine "psync")" "--rw=randwrite" "--direct=1")
 	opts+=("--max_open_zones=4" "--group_reporting=1")
 	opts+=("--zonemode=zbd" "--zonesize=${zone_size}")
-	opts+=(${var_opts[@]})
+	# max_open_zones is already specified
+	opts+=($(job_var_opts_exclude "--max_open_zones"))
     done
     run_fio "${opts[@]}" >> "${logfile}.${test_number}" 2>&1 || return $?
     check_written $((jobs * zone_size)) || return $?
@@ -617,7 +649,7 @@ test31() {
 	opts+=("--bs=$bs" "--size=$zone_size" "$(ioengine "libaio")")
 	opts+=("--rw=write" "--direct=1" "--thread=1" "--stats=0")
 	opts+=("--zonemode=zbd" "--zonesize=${zone_size}")
-	opts+=(${var_opts[@]})
+	opts+=(${job_var_opts[@]})
     done
     "$(dirname "$0")/../../fio" "${opts[@]}" >> "${logfile}.${test_number}" 2>&1
     # Next, run the test.
@@ -627,6 +659,7 @@ test31() {
     opts+=("--bs=$bs" "$(ioengine "psync")" "--rw=randread" "--direct=1")
     opts+=("--thread=1" "--time_based" "--runtime=30" "--zonemode=zbd")
     opts+=("--zonesize=${zone_size}")
+    opts+=(${job_var_opts[@]})
     run_fio "${opts[@]}" >> "${logfile}.${test_number}" 2>&1 || return $?
 }
 
@@ -843,6 +876,8 @@ test48() {
 	opts+=("--name=job$i" "--filename=$dev" "--offset=$off" "--bs=16K")
 	opts+=("--io_size=$zone_size" "--iodepth=256" "--thread=1")
 	opts+=("--group_reporting=1")
+	# max_open_zones is already specified
+	opts+=($(job_var_opts_exclude "--max_open_zones"))
     done
 
     fio=$(dirname "$0")/../../fio
@@ -880,6 +915,7 @@ dynamic_analyzer=()
 reset_all_zones=
 use_libzbc=
 zbd_debug=
+max_open_zones_opt=
 
 while [ "${1#-}" != "$1" ]; do
   case "$1" in
@@ -891,6 +927,7 @@ while [ "${1#-}" != "$1" ]; do
     -l) use_libzbc=1; shift;;
     -r) reset_all_zones=1; shift;;
     -t) tests+=("$2"); shift; shift;;
+    -o) max_open_zones_opt="${2}"; shift; shift;;
     -v) dynamic_analyzer=(valgrind "--read-var-info=yes");
 	shift;;
     -z) zbd_debug=1; shift;;
@@ -906,9 +943,10 @@ fi
 # shellcheck source=functions
 source "$(dirname "$0")/functions" || exit $?
 
-var_opts=()
+global_var_opts=()
+job_var_opts=()
 if [ -n "$zbd_debug" ]; then
-    var_opts+=("--debug=zbd")
+    global_var_opts+=("--debug=zbd")
 fi
 dev=$1
 realdev=$(readlink -f "$dev")
@@ -994,6 +1032,12 @@ elif [[ -c "$realdev" ]]; then
 	fi
 fi
 
+if [[ -n ${max_open_zones_opt} ]]; then
+	# Override max_open_zones with the script option value
+	max_open_zones="${max_open_zones_opt}"
+	job_var_opts+=("--max_open_zones=${max_open_zones_opt}")
+fi
+
 echo -n "First sequential zone starts at sector $first_sequential_zone_sector;"
 echo " zone size: $((zone_size >> 20)) MB"
 
-- 
2.26.2


