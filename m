Return-Path: <caio@google.com>
MIME-Version: 1.0
In-Reply-To: <CADp+U7i=OPhuF9+nB1MW0ScaPv5sX3mL4ASdJ-8AGrDMfX71oA@mail.gmail.com>
References: <CADp+U7ibiKciX8_cpzGzob4oL-UF-H+W7kYuiujovD0ba=hM6A@mail.gmail.com>
	<56464ACC.9030605@kernel.dk>
	<CADp+U7gHq5VJgRFzGXvHTKN8Tyz9NDUZGePDWQ548ciyJmGr7A@mail.gmail.com>
	<56465F00.1060504@kernel.dk>
	<CADp+U7i=OPhuF9+nB1MW0ScaPv5sX3mL4ASdJ-8AGrDMfX71oA@mail.gmail.com>
Date: Fri, 20 Nov 2015 11:37:53 -0800
Message-ID: <CAFXh1QgZNghYY9CKJY5BZA4=ARGzXWYVHBBpHxV724qu2Wd5Hw@mail.gmail.com>
Subject: Re: Running a separate fio process for each disk?
From: Caio Villela <caio@google.com>
Content-Type: multipart/alternative; boundary=001a1140f36afd55af0524fe0258
To: Allen Schade <aschade@google.com>
Cc: Jens Axboe <axboe@kernel.dk>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

--001a1140f36afd55af0524fe0258
Content-Type: text/plain; charset=UTF-8

Hello Allen and Jens,

Sorry for the long output, this is just in case you want the details.
Here is a simple explanation for the problem. I want to run a 15 minute
random write, using 1 Meg requests, and measure throughput and latency.
What seems to be the problem is that if the test system has a large number
of drives - the system that I am testing here has 28 drives - then the time
accounting seems to go bad for some of the processes.
What you see below is that during the 15 minutes from start, all disks are
getting hit the same, as they should. Then, after 15 minutes, there are 15
drives that are still running.... after 5 minutes over the specified 15
minutes, there is still one drive running. Then looking at the amount of
IOs sent to each drive, the ones that ran on that excess time have much
more IOs. FIO still reports that all drives ran for 15 minutes, although
some ran for more than 20 minutes.

We will attempt to run a single process instead of 28 instances of FIO to
see if this goes away.

Details:

I have the following control file to do this:

cat write_random_1M.fio
# Synthetic Latency Analysis Experimental FIO Control File
# Copyright (C) 2015 CODENAME
# Shared with VENDOR under NDA.
# Authors: Caio Villela

# --------------------Global Settings--------------------#

[global]
runtime=900
ioengine=sync
time_based=1
norandommap=1
bwavgtime=5000
direct=1
thread=1
do_verify=0
numjobs=1
continue_on_error=io
ramp_time=10

# ----------------Pure Random Workloads----------------#

# Random Write Workload
# 100% Writes @1024k
[random_write_1024k]
rw=randwrite
bs=1048576

I am monitoring the number of IOs per drive by using the script

cat disp_total_iops_512k.sh
for i in b c d e f g h i j k l m n o p q r s t u v w x y z aa ab ac; do
echo -n "sd$i "; cat /sys/block/sd$i/write_request_histo | grep 524288 |
awk '{print $2 + $3 + $4 + $5 + $6 + $7 + $8 + $9 + $10 + $11 + $12}'; done

And as you can see it starts with all drives with zero IOs.


****___ EXPERIMENT WITH 28 DRIVES   ____*****

Starts at 10:07:33, should end at 10:22:33


cln4:/home/hdd_test# date; ./disp_total_iops_512k.sh
Thu Nov 19 10:07:33 PST 2015
sdb 0
sdc 0
sdd 0
sde 0
sdf 0
sdg 0
sdh 0
sdi 0
sdj 0
sdk 0
sdl 0
sdm 0
sdn 0
sdo 0
sdp 0
sdq 0
sdr 0
sds 0
sdt 0
sdu 0
sdv 0
sdw 0
sdx 0
sdy 0
sdz 0
sdaa 0
sdab 0
sdac 0


cln4:/home/hdd_test# date; ./disp_total_iops_512k.sh
Thu Nov 19 10:09:24 PST 2015
sdb 21732
sdc 21835
sdd 21655
sde 21907
sdf 21949
sdg 21753
sdh 21863
sdi 21745
sdj 21679
sdk 21621
sdl 21894
sdm 21437
sdn 21555
sdo 21492
sdp 21677
sdq 21717
sdr 21736
sds 21350
sdt 21909
sdu 22082
sdv 22148
sdw 21778
sdx 21380
sdy 21770
sdz 21749
sdaa 22161
sdab 21798
sdac 21485

cln4:/home/hdd_test# date; ./disp_total_iops_512k.sh
Thu Nov 19 10:13:33 PST 2015
sdb 71328
sdc 71811
sdd 70860
sde 71680
sdf 71743
sdg 71171
sdh 71843
sdi 71512
sdj 71328
sdk 70977
sdl 71614
sdm 70715
sdn 70622
sdo 70424
sdp 71338
sdq 70990
sdr 71458
sds 70082
sdt 71995
sdu 72433
sdv 72504
sdw 71687
sdx 70402
sdy 71299
sdz 71376
sdaa 72729
sdab 71302
sdac 70775

cln4:/home/hdd_test# date; ./disp_total_iops_512k.sh
Thu Nov 19 10:22:25 PST 2015
sdb 177075
sdc 178134
sdd 176100
sde 178115
sdf 177950
sdg 176743
sdh 178478
sdi 177500
sdj 177239
sdk 176294
sdl 177594
sdm 175325
sdn 175189
sdo 174962
sdp 177076
sdq 176177
sdr 177336
sds 173842
sdt 178753
sdu 179514
sdv 179681
sdw 178229
sdx 174532
sdy 176912
sdz 176911
sdaa 180506
sdab 177070
sdac 175550
cln4:/home/hdd_test# date; ./disp_total_iops_512k.sh
Thu Nov 19 10:22:31 PST 2015 ---->> SHOULD END HERE !!!!
sdb 178204
sdc 179207
sdd 177169
sde 179235
sdf 179028
sdg 177822
sdh 179602
sdi 178644
sdj 178364
sdk 177397
sdl 178707
sdm 176411
sdn 176273
sdo 176054
sdp 178182
sdq 177258
sdr 178428
sds 174951
sdt 179844
sdu 180614
sdv 180792
sdw 179292
sdx 175625
sdy 178005
sdz 177983
sdaa 181612
sdab 178120
sdac 176646

Device:            tps    kB_read/s    kB_wrtn/s    kB_read    kB_wrtn
sda              41.50      1678.00         0.00       3356          0
sdb             170.00         0.00     87040.00          0     174080
sdc             186.50         0.00     95488.00          0     190976
sdd             210.00         0.00    107520.00          0     215040
sde               0.00         0.00         0.00          0          0
sdf               0.00         0.00         0.00          0          0
sdg               0.00         0.00         0.00          0          0
sdh             221.00         0.00    113152.00          0     226304
sdi             208.50         0.00    106752.00          0     213504
sdj             201.00         0.00    102912.00          0     205824
sdk             209.50         0.00    107264.00          0     214528
sdl             204.50         0.00    104704.00          0     209408
sdm             206.00         0.00    105472.00          0     210944
sdn               0.00         0.00         0.00          0          0
sdo               0.00         0.00         0.00          0          0
sdp               0.00         0.00         0.00          0          0
sdq               0.00         0.00         0.00          0          0
sdr             194.50         0.00     99584.00          0     199168
sds             192.00         0.00     98304.00          0     196608
sdt             198.00         0.00    101376.00          0     202752
sdu               0.00         0.00         0.00          0          0
sdv               0.00         0.00         0.00          0          0
sdw               0.00         0.00         0.00          0          0
sdx             211.00         0.00    108032.00          0     216064
sdy             205.00         0.00    104960.00          0     209920
sdz               0.00         0.00         0.00          0          0
sdaa              0.00         0.00         0.00          0          0
sdab            205.50         0.00    105216.00          0     210432
sdac              0.00         0.00         0.00          0          0


Device:            tps    kB_read/s    kB_wrtn/s    kB_read    kB_wrtn
sda              55.50      1842.00        32.00       3684         64
sdb             186.50         0.00     95488.00          0     190976
sdc               0.00         0.00         0.00          0          0
sdd             212.50         0.00    108800.00          0     217600
sde               0.00         0.00         0.00          0          0
sdf               0.00         0.00         0.00          0          0
sdg               0.00         0.00         0.00          0          0
sdh             217.00         0.00    111104.00          0     222208
sdi             206.50         0.00    105728.00          0     211456
sdj             195.50         0.00    100096.00          0     200192
sdk             201.00         0.00    102912.00          0     205824
sdl             199.00         0.00    101888.00          0     203776
sdm               0.00         0.00         0.00          0          0
sdn               0.00         0.00         0.00          0          0
sdo               0.00         0.00         0.00          0          0
sdp               0.00         0.00         0.00          0          0
sdq               0.00         0.00         0.00          0          0
sdr             181.00         0.00     92672.00          0     185344
sds             192.50         0.00     98560.00          0     197120
sdt             207.50         0.00    106240.00          0     212480
sdu               0.00         0.00         0.00          0          0
sdv               0.00         0.00         0.00          0          0
sdw               0.00         0.00         0.00          0          0
sdx             211.00         0.00    108032.00          0     216064
sdy             190.00         0.00     97280.00          0     194560
sdz               0.00         0.00         0.00          0          0
sdaa              0.00         0.00         0.00          0          0
sdab            202.50         0.00    103680.00          0     207360
sdac              0.00         0.00         0.00          0          0



cln4:/home/hdd_test# date; ./disp_total_iops_512k.sh
Thu Nov 19 10:23:12 PST 2015
sdb 186323
sdc 183418
sdd 185207
sde 182338
sdf 182166
sdg 181010
sdh 187822
sdi 186776
sdj 186457
sdk 184790
sdl 186859
sdm 181900
sdn 179394
sdo 179228
sdp 181386
sdq 180374
sdr 186584
sds 181994
sdt 188087
sdu 183868
sdv 183976
sdw 182562
sdx 183664
sdy 186096
sdz 181240
sdaa 184892
sdab 186197
sdac 179804

Device:            tps    kB_read/s    kB_wrtn/s    kB_read    kB_wrtn
sda              17.00       362.00        56.00        724        112
sdb             207.50         0.00    106240.00          0     212480
sdc               0.00         0.00         0.00          0          0
sdd             190.50         0.00     97536.00          0     195072
sde               0.00         0.00         0.00          0          0
sdf               0.00         0.00         0.00          0          0
sdg               0.00         0.00         0.00          0          0
sdh             189.50         0.00     97024.00          0     194048
sdi               0.00         0.00         0.00          0          0
sdj             208.00         0.00    106496.00          0     212992
sdk               0.00         0.00         0.00          0          0
sdl             195.50         0.00    100096.00          0     200192
sdm               0.00         0.00         0.00          0          0
sdn               0.00         0.00         0.00          0          0
sdo               0.00         0.00         0.00          0          0
sdp               0.00         0.00         0.00          0          0
sdq               0.00         0.00         0.00          0          0
sdr             213.00         0.00    109056.00          0     218112
sds               0.00         0.00         0.00          0          0
sdt             208.00         0.00    106496.00          0     212992
sdu               0.00         0.00         0.00          0          0
sdv               0.00         0.00         0.00          0          0
sdw               0.00         0.00         0.00          0          0
sdx             199.50         0.00    102144.00          0     204288
sdy             189.50         0.00     97024.00          0     194048
sdz               0.00         0.00         0.00          0          0
sdaa              0.00         0.00         0.00          0          0
sdab            215.00         0.00    110080.00          0     220160
sdac              0.00         0.00         0.00          0          0

cln4:/home/hdd_test# date; ./disp_total_iops_512k.sh
Thu Nov 19 10:23:29 PST 2015
sdb 189869
sdc 183418
sdd 188716
sde 182338
sdf 182166
sdg 181010
sdh 191382
sdi 187256
sdj 190025
sdk 184790
sdl 190415
sdm 181900
sdn 179394
sdo 179228
sdp 181386
sdq 180374
sdr 190136
sds 181994
sdt 191684
sdu 183868
sdv 183976
sdw 182562
sdx 187147
sdy 189641
sdz 181240
sdaa 184892
sdab 189731
sdac 179804

Device:            tps    kB_read/s    kB_wrtn/s    kB_read    kB_wrtn
sda              41.50      1712.00         0.00       3424          0
sdb             206.00         0.00    105472.00          0     210944
sdc               0.00         0.00         0.00          0          0
sdd             198.50         0.00    101632.00          0     203264
sde               0.00         0.00         0.00          0          0
sdf               0.00         0.00         0.00          0          0
sdg               0.00         0.00         0.00          0          0
sdh             189.00         0.00     96768.00          0     193536
sdi               0.00         0.00         0.00          0          0
sdj             199.50         0.00    102144.00          0     204288
sdk               0.00         0.00         0.00          0          0
sdl             203.00         0.00    103936.00          0     207872
sdm               0.00         0.00         0.00          0          0
sdn               0.00         0.00         0.00          0          0
sdo               0.00         0.00         0.00          0          0
sdp               0.00         0.00         0.00          0          0
sdq               0.00         0.00         0.00          0          0
sdr             201.00         0.00    102912.00          0     205824
sds               0.00         0.00         0.00          0          0
sdt             195.00         0.00     99840.00          0     199680
sdu               0.00         0.00         0.00          0          0
sdv               0.00         0.00         0.00          0          0
sdw               0.00         0.00         0.00          0          0
sdx             202.00         0.00    103424.00          0     206848
sdy              31.50         0.00     16128.00          0      32256
sdz               0.00         0.00         0.00          0          0
sdaa              0.00         0.00         0.00          0          0
sdab              0.00         0.00         0.00          0          0
sdac              0.00         0.00         0.00          0          0

cln4:/home/hdd_test# date; ./disp_total_iops_512k.sh
Thu Nov 19 10:23:55 PST 2015
sdb 194927
sdc 183418
sdd 193720
sde 182338
sdf 182166
sdg 181010
sdh 196466
sdi 187256
sdj 195111
sdk 184790
sdl 195463
sdm 181900
sdn 179394
sdo 179228
sdp 181386
sdq 180374
sdr 195167
sds 181994
sdt 196775
sdu 183868
sdv 183976
sdw 182562
sdx 192105
sdy 192874
sdz 181240
sdaa 184892
sdab 191350
sdac 179804

Device:            tps    kB_read/s    kB_wrtn/s    kB_read    kB_wrtn
sda              61.50      2086.00         0.00       4172          0
sdb             189.00         0.00     96768.00          0     193536
sdc               0.00         0.00         0.00          0          0
sdd             200.00         0.00    102400.00          0     204800
sde               0.00         0.00         0.00          0          0
sdf               0.00         0.00         0.00          0          0
sdg               0.00         0.00         0.00          0          0
sdh               0.00         0.00         0.00          0          0
sdi               0.00         0.00         0.00          0          0
sdj               0.00         0.00         0.00          0          0
sdk               0.00         0.00         0.00          0          0
sdl             184.50         0.00     94464.00          0     188928
sdm               0.00         0.00         0.00          0          0
sdn               0.00         0.00         0.00          0          0
sdo               0.00         0.00         0.00          0          0
sdp               0.00         0.00         0.00          0          0
sdq               0.00         0.00         0.00          0          0
sdr             215.50         0.00    110336.00          0     220672
sds               0.00         0.00         0.00          0          0
sdt             223.00         0.00    114176.00          0     228352
sdu               0.00         0.00         0.00          0          0
sdv               0.00         0.00         0.00          0          0
sdw               0.00         0.00         0.00          0          0
sdx             205.00         0.00    104960.00          0     209920
sdy               0.00         0.00         0.00          0          0
sdz               0.00         0.00         0.00          0          0
sdaa              0.00         0.00         0.00          0          0
sdab              0.00         0.00         0.00          0          0
sdac              0.00         0.00         0.00          0          0

cln4:/home/hdd_test# date; ./disp_total_iops_512k.sh
Thu Nov 19 10:24:36 PST 2015
sdb 203100
sdc 183418
sdd 201814
sde 182338
sdf 182166
sdg 181010
sdh 201704
sdi 187256
sdj 200326
sdk 184790
sdl 203577
sdm 181900
sdn 179394
sdo 179228
sdp 181386
sdq 180374
sdr 203330
sds 181994
sdt 204983
sdu 183868
sdv 183976
sdw 182562
sdx 200165
sdy 192874
sdz 181240
sdaa 184892
sdab 191350
sdac 179804

Device:            tps    kB_read/s    kB_wrtn/s    kB_read    kB_wrtn
sda              18.50      2060.00         8.00       4120         16
sdb               0.00         0.00         0.00          0          0
sdc               0.00         0.00         0.00          0          0
sdd             204.50         0.00    104704.00          0     209408
sde               0.00         0.00         0.00          0          0
sdf               0.00         0.00         0.00          0          0
sdg               0.00         0.00         0.00          0          0
sdh               0.00         0.00         0.00          0          0
sdi               0.00         0.00         0.00          0          0
sdj               0.00         0.00         0.00          0          0
sdk               0.00         0.00         0.00          0          0
sdl             209.50         0.00    107264.00          0     214528
sdm               0.00         0.00         0.00          0          0
sdn               0.00         0.00         0.00          0          0
sdo               0.00         0.00         0.00          0          0
sdp               0.00         0.00         0.00          0          0
sdq               0.00         0.00         0.00          0          0
sdr             208.00         0.00    106496.00          0     212992
sds               0.00         0.00         0.00          0          0
sdt             210.00         0.00    107520.00          0     215040
sdu               0.00         0.00         0.00          0          0
sdv               0.00         0.00         0.00          0          0
sdw               0.00         0.00         0.00          0          0
sdx               0.00         0.00         0.00          0          0
sdy               0.00         0.00         0.00          0          0
sdz               0.00         0.00         0.00          0          0
sdaa              0.00         0.00         0.00          0          0
sdab              0.00         0.00         0.00          0          0
sdac              0.00         0.00         0.00          0          0

cln4:/home/hdd_test# date; ./disp_total_iops_512k.sh
Thu Nov 19 10:25:09 PST 2015
sdb 207564
sdc 183418
sdd 208503
sde 182338
sdf 182166
sdg 181010
sdh 201704
sdi 187256
sdj 200326
sdk 184790
sdl 210362
sdm 181900
sdn 179394
sdo 179228
sdp 181386
sdq 180374
sdr 210114
sds 181994
sdt 211744
sdu 183868
sdv 183976
sdw 182562
sdx 201236
sdy 192874
sdz 181240
sdaa 184892
sdab 191350
sdac 179804

Device:            tps    kB_read/s    kB_wrtn/s    kB_read    kB_wrtn
sda              19.00      2050.00        12.00       4100         24
sdb               0.00         0.00         0.00          0          0
sdc               0.00         0.00         0.00          0          0
sdd             195.00         0.00     99840.00          0     199680
sde               0.00         0.00         0.00          0          0
sdf               0.00         0.00         0.00          0          0
sdg               0.00         0.00         0.00          0          0
sdh               0.00         0.00         0.00          0          0
sdi               0.00         0.00         0.00          0          0
sdj               0.00         0.00         0.00          0          0
sdk               0.00         0.00         0.00          0          0
sdl             197.00         0.00    100864.00          0     201728
sdm               0.00         0.00         0.00          0          0
sdn               0.00         0.00         0.00          0          0
sdo               0.00         0.00         0.00          0          0
sdp               0.00         0.00         0.00          0          0
sdq               0.00         0.00         0.00          0          0
sdr             212.00         0.00    108544.00          0     217088
sds               0.00         0.00         0.00          0          0
sdt             198.00         0.00    101376.00          0     202752
sdu               0.00         0.00         0.00          0          0
sdv               0.00         0.00         0.00          0          0
sdw               0.00         0.00         0.00          0          0
sdx               0.00         0.00         0.00          0          0
sdy               0.00         0.00         0.00          0          0
sdz               0.00         0.00         0.00          0          0
sdaa              0.00         0.00         0.00          0          0
sdab              0.00         0.00         0.00          0          0
sdac              0.00         0.00         0.00          0          0


cln4:/home/hdd_test# date; ./disp_total_iops_512k.sh
Thu Nov 19 10:26:12 PST 2015
sdb 207564
sdc 183418
sdd 220962
sde 182338
sdf 182166
sdg 181010
sdh 201704
sdi 187256
sdj 200326
sdk 184790
sdl 222883
sdm 181900
sdn 179394
sdo 179228
sdp 181386
sdq 180374
sdr 222560
sds 181994
sdt 224287
sdu 183868
sdv 183976
sdw 182562
sdx 201236
sdy 192874
sdz 181240
sdaa 184892
sdab 191350
sdac 179804




Device:            tps    kB_read/s    kB_wrtn/s    kB_read    kB_wrtn
sda              19.50      2128.00         0.00       4256          0
sdb               0.00         0.00         0.00          0          0
sdc               0.00         0.00         0.00          0          0
sdd             219.00         0.00    112128.00          0     224256
sde               0.00         0.00         0.00          0          0
sdf               0.00         0.00         0.00          0          0
sdg               0.00         0.00         0.00          0          0
sdh               0.00         0.00         0.00          0          0
sdi               0.00         0.00         0.00          0          0
sdj               0.00         0.00         0.00          0          0
sdk               0.00         0.00         0.00          0          0
sdl               0.00         0.00         0.00          0          0
sdm               0.00         0.00         0.00          0          0
sdn               0.00         0.00         0.00          0          0
sdo               0.00         0.00         0.00          0          0
sdp               0.00         0.00         0.00          0          0
sdq               0.00         0.00         0.00          0          0
sdr             207.00         0.00    105984.00          0     211968
sds               0.00         0.00         0.00          0          0
sdt             183.50         0.00     93952.00          0     187904
sdu               0.00         0.00         0.00          0          0
sdv               0.00         0.00         0.00          0          0
sdw               0.00         0.00         0.00          0          0
sdx               0.00         0.00         0.00          0          0
sdy               0.00         0.00         0.00          0          0
sdz               0.00         0.00         0.00          0          0
sdaa              0.00         0.00         0.00          0          0
sdab              0.00         0.00         0.00          0          0
sdac              0.00         0.00         0.00          0          0

cln4:/home/hdd_test# date; ./disp_total_iops_512k.sh
Thu Nov 19 10:27:00 PST 2015
sdb 207564
sdc 183418
sdd 230499
sde 182338
sdf 182166
sdg 181010
sdh 201704
sdi 187256
sdj 200326
sdk 184790
sdl 228202
sdm 181900
sdn 179394
sdo 179228
sdp 181386
sdq 180374
sdr 232184
sds 181994
sdt 234098
sdu 183868
sdv 183976
sdw 182562
sdx 201236
sdy 192874
sdz 181240
sdaa 184892
sdab 191350
sdac 179804



Device:            tps    kB_read/s    kB_wrtn/s    kB_read    kB_wrtn
sda              19.00      2056.00         8.00       4112         16
sdb               0.00         0.00         0.00          0          0
sdc               0.00         0.00         0.00          0          0
sdd               0.00         0.00         0.00          0          0
sde               0.00         0.00         0.00          0          0
sdf               0.00         0.00         0.00          0          0
sdg               0.00         0.00         0.00          0          0
sdh               0.00         0.00         0.00          0          0
sdi               0.00         0.00         0.00          0          0
sdj               0.00         0.00         0.00          0          0
sdk               0.00         0.00         0.00          0          0
sdl               0.00         0.00         0.00          0          0
sdm               0.00         0.00         0.00          0          0
sdn               0.00         0.00         0.00          0          0
sdo               0.00         0.00         0.00          0          0
sdp               0.00         0.00         0.00          0          0
sdq               0.00         0.00         0.00          0          0
sdr             197.00         0.00    100864.00          0     201728
sds               0.00         0.00         0.00          0          0
sdt               0.00         0.00         0.00          0          0
sdu               0.00         0.00         0.00          0          0
sdv               0.00         0.00         0.00          0          0
sdw               0.00         0.00         0.00          0          0
sdx               0.00         0.00         0.00          0          0
sdy               0.00         0.00         0.00          0          0
sdz               0.00         0.00         0.00          0          0
sdaa              0.00         0.00         0.00          0          0
sdab              0.00         0.00         0.00          0          0
sdac              0.00         0.00         0.00          0          0
cln4:/home/hdd_test# date; ./disp_total_iops_512k.sh
Thu Nov 19 10:27:31 PST 2015
sdb 207564
sdc 183418
sdd 232922
sde 182338
sdf 182166
sdg 181010
sdh 201704
sdi 187256
sdj 200326
sdk 184790
sdl 228202
sdm 181900
sdn 179394
sdo 179228
sdp 181386
sdq 180374
sdr 238277
sds 181994
sdt 238404
sdu 183868
sdv 183976
sdw 182562
sdx 201236
sdy 192874
sdz 181240
sdaa 184892
sdab 191350
sdac 179804


All done at more than 5 minutes past the 15 minute mark.

cln4:/home/hdd_test# date; ./disp_total_iops_512k.sh
Thu Nov 19 10:27:51 PST 2015
sdb 207564
sdc 183418
sdd 232922
sde 182338
sdf 182166
sdg 181010
sdh 201704
sdi 187256
sdj 200326
sdk 184790
sdl 228202
sdm 181900
sdn 179394
sdo 179228
sdp 181386
sdq 180374
sdr 238426
sds 181994
sdt 238404
sdu 183868
sdv 183976
sdw 182562
sdx 201236
sdy 192874
sdz 181240
sdaa 184892
sdab 191350
sdac 179804

On Fri, Nov 20, 2015 at 10:28 AM, Allen Schade <aschade@google.com> wrote:

> Jens,
> We tried with the latest version and gathered some detailed info.
>
> Hey Caio,
> Can you paste your experiment information as a reply here. Also switch
> your email to plain text mode or the vger.kernel.org email address
> will reject your email as spam.
>
> On Fri, Nov 13, 2015 at 2:06 PM, Jens Axboe <axboe@kernel.dk> wrote:
> > On 11/13/2015 03:04 PM, Allen Schade wrote:
> >>
> >> I'm actually launching a completely separate instance of fio for each
> >> disk. I want to say its because when I ran them under the same fio
> >> process I had issues with the json files merging the data in an
> >> unexpected way.
> >
> >
> > OK - in any case, that should be fine.
> >
> >> Version is 2.2.6
> >
> >
> > Could you try current -git? I vaguely remember some clock issue that
> could
> > have caused this.
> >
> > --
> > Jens Axboe
> >
>

--001a1140f36afd55af0524fe0258
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Hello Allen and Jens,<div><br></div><div>Sorry for the lon=
g output, this is just in case you want the details.</div><div>Here is a si=
mple explanation for the problem. I want to run a 15 minute random write, u=
sing 1 Meg requests, and measure throughput and latency.</div><div>What see=
ms to be the problem is that if the test system has a large number of drive=
s - the system that I am testing here has 28 drives - then the time account=
ing seems to go bad for some of the processes.</div><div>What you see below=
 is that during the 15 minutes from start, all disks are getting hit the sa=
me, as they should. Then, after 15 minutes, there are 15 drives that are st=
ill running.... after 5 minutes over the specified 15 minutes, there is sti=
ll one drive running. Then looking at the amount of IOs sent to each drive,=
 the ones that ran on that excess time have much more IOs. FIO still report=
s that all drives ran for 15 minutes, although some ran for more than 20 mi=
nutes.</div><div><br></div><div>We will attempt to run a single process ins=
tead of 28 instances of FIO to see if this goes away.</div><div><br></div><=
div>Details:</div><div><br></div><div>I have the following control file to =
do this:</div><div><br></div><div><div><font face=3D"monospace, monospace">=
cat write_random_1M.fio=C2=A0</font></div><div><font face=3D"monospace, mon=
ospace"># Synthetic Latency Analysis Experimental FIO Control File</font></=
div><div><font face=3D"monospace, monospace"># Copyright (C) 2015 CODENAME<=
/font></div><div><font face=3D"monospace, monospace"># Shared with VENDOR u=
nder NDA.</font></div><div><font face=3D"monospace, monospace"># Authors: C=
aio Villela</font></div><div><font face=3D"monospace, monospace"><br></font=
></div><div><font face=3D"monospace, monospace"># --------------------Globa=
l Settings--------------------#</font></div><div><font face=3D"monospace, m=
onospace"><br></font></div><div><font face=3D"monospace, monospace">[global=
]</font></div><div><font face=3D"monospace, monospace">runtime=3D900</font>=
</div><div><font face=3D"monospace, monospace">ioengine=3Dsync</font></div>=
<div><font face=3D"monospace, monospace">time_based=3D1</font></div><div><f=
ont face=3D"monospace, monospace">norandommap=3D1</font></div><div><font fa=
ce=3D"monospace, monospace">bwavgtime=3D5000</font></div><div><font face=3D=
"monospace, monospace">direct=3D1</font></div><div><font face=3D"monospace,=
 monospace">thread=3D1</font></div><div><font face=3D"monospace, monospace"=
>do_verify=3D0</font></div><div><font face=3D"monospace, monospace">numjobs=
=3D1</font></div><div><font face=3D"monospace, monospace">continue_on_error=
=3Dio</font></div><div><font face=3D"monospace, monospace">ramp_time=3D10</=
font></div><div><font face=3D"monospace, monospace"><br></font></div><div><=
font face=3D"monospace, monospace"># ----------------Pure Random Workloads-=
---------------#</font></div><div><font face=3D"monospace, monospace"><br><=
/font></div><div><font face=3D"monospace, monospace"># Random Write Workloa=
d</font></div><div><font face=3D"monospace, monospace"># 100% Writes @1024k=
</font></div><div><font face=3D"monospace, monospace">[random_write_1024k]<=
/font></div><div><font face=3D"monospace, monospace">rw=3Drandwrite</font><=
/div><div><font face=3D"monospace, monospace">bs=3D1048576</font></div></di=
v><div><br></div><div>I am monitoring the number of IOs per drive by using =
the script=C2=A0</div><div><div><br></div><div><font face=3D"monospace, mon=
ospace">cat disp_total_iops_512k.sh=C2=A0</font></div><div><font face=3D"mo=
nospace, monospace">for i in b c d e f g h i j k l m n o p q r s t u v w x =
y z aa ab ac; do echo -n &quot;sd$i &quot;; cat /sys/block/sd$i/write_reque=
st_histo | grep 524288 | awk &#39;{print $2 + $3 + $4 + $5 + $6 + $7 + $8 +=
 $9 + $10 + $11 + $12}&#39;; done</font></div></div><div><br></div><div>And=
 as you can see it starts with all drives with zero IOs.</div><div><br></di=
v><div><br><div><div style=3D"font-size:12.8px"><font face=3D"monospace, mo=
nospace">****___ EXPERIMENT WITH 28 DRIVES =C2=A0 ____*****</font></div><di=
v style=3D"font-size:12.8px"><font face=3D"monospace, monospace"><br></font=
></div><div style=3D"font-size:12.8px"><font face=3D"monospace, monospace">=
Starts at <span style=3D"background-color:rgb(255,255,0)">10:07:33</span>, =
should end at <span style=3D"background-color:rgb(255,255,0)">10:22:33</spa=
n></font></div><div style=3D"font-size:12.8px"><font face=3D"monospace, mon=
ospace"><br></font></div><div style=3D"font-size:12.8px"><font face=3D"mono=
space, monospace"><br></font></div><div style=3D"font-size:12.8px"><font fa=
ce=3D"monospace, monospace">cln4:/home/hdd_test# date; ./disp_total_iops_51=
2k.sh=C2=A0</font></div><div style=3D"font-size:12.8px"><font face=3D"monos=
pace, monospace">Thu Nov 19 10:07:33 PST 2015</font></div><span class=3D"im=
" style=3D"font-size:12.8px"><div><font face=3D"monospace, monospace">sdb 0=
</font></div><div><font face=3D"monospace, monospace">sdc 0</font></div><di=
v><font face=3D"monospace, monospace">sdd 0</font></div><div><font face=3D"=
monospace, monospace">sde 0</font></div><div><font face=3D"monospace, monos=
pace">sdf 0</font></div><div><font face=3D"monospace, monospace">sdg 0</fon=
t></div><div><font face=3D"monospace, monospace">sdh 0</font></div><div><fo=
nt face=3D"monospace, monospace">sdi 0</font></div><div><font face=3D"monos=
pace, monospace">sdj 0</font></div><div><font face=3D"monospace, monospace"=
>sdk 0</font></div><div><font face=3D"monospace, monospace">sdl 0</font></d=
iv><div><font face=3D"monospace, monospace">sdm 0</font></div><div><font fa=
ce=3D"monospace, monospace">sdn 0</font></div></span><div style=3D"font-siz=
e:12.8px"><font face=3D"monospace, monospace">sdo 0</font></div><div style=
=3D"font-size:12.8px"><font face=3D"monospace, monospace">sdp 0</font></div=
><div style=3D"font-size:12.8px"><font face=3D"monospace, monospace">sdq 0<=
/font></div><div style=3D"font-size:12.8px"><font face=3D"monospace, monosp=
ace">sdr 0</font></div><div style=3D"font-size:12.8px"><font face=3D"monosp=
ace, monospace">sds 0</font></div><div style=3D"font-size:12.8px"><font fac=
e=3D"monospace, monospace">sdt 0</font></div><div style=3D"font-size:12.8px=
"><font face=3D"monospace, monospace">sdu 0</font></div><div style=3D"font-=
size:12.8px"><font face=3D"monospace, monospace">sdv 0</font></div><div sty=
le=3D"font-size:12.8px"><font face=3D"monospace, monospace">sdw 0</font></d=
iv><div style=3D"font-size:12.8px"><font face=3D"monospace, monospace">sdx =
0</font></div><div style=3D"font-size:12.8px"><font face=3D"monospace, mono=
space">sdy 0</font></div><div style=3D"font-size:12.8px"><font face=3D"mono=
space, monospace">sdz 0</font></div><div style=3D"font-size:12.8px"><font f=
ace=3D"monospace, monospace">sdaa 0</font></div><div style=3D"font-size:12.=
8px"><font face=3D"monospace, monospace">sdab 0</font></div><div style=3D"f=
ont-size:12.8px"><font face=3D"monospace, monospace">sdac 0</font></div><di=
v style=3D"font-size:12.8px"><font face=3D"monospace, monospace"><br></font=
></div><div style=3D"font-size:12.8px"><font face=3D"monospace, monospace">=
<br></font></div><div style=3D"font-size:12.8px"><font face=3D"monospace, m=
onospace">cln4:/home/hdd_test# date; ./disp_total_iops_512k.sh=C2=A0</font>=
</div><div style=3D"font-size:12.8px"><font face=3D"monospace, monospace">T=
hu Nov 19 10:09:24 PST 2015</font></div><div style=3D"font-size:12.8px"><fo=
nt face=3D"monospace, monospace">sdb 21732</font></div><div style=3D"font-s=
ize:12.8px"><font face=3D"monospace, monospace">sdc 21835</font></div><div =
style=3D"font-size:12.8px"><font face=3D"monospace, monospace">sdd 21655</f=
ont></div><div style=3D"font-size:12.8px"><font face=3D"monospace, monospac=
e">sde 21907</font></div><div style=3D"font-size:12.8px"><font face=3D"mono=
space, monospace">sdf 21949</font></div><div style=3D"font-size:12.8px"><fo=
nt face=3D"monospace, monospace">sdg 21753</font></div><div style=3D"font-s=
ize:12.8px"><font face=3D"monospace, monospace">sdh 21863</font></div><div =
style=3D"font-size:12.8px"><font face=3D"monospace, monospace">sdi 21745</f=
ont></div><div style=3D"font-size:12.8px"><font face=3D"monospace, monospac=
e">sdj 21679</font></div><div style=3D"font-size:12.8px"><font face=3D"mono=
space, monospace">sdk 21621</font></div><div style=3D"font-size:12.8px"><fo=
nt face=3D"monospace, monospace">sdl 21894</font></div><div style=3D"font-s=
ize:12.8px"><font face=3D"monospace, monospace">sdm 21437</font></div><div =
style=3D"font-size:12.8px"><font face=3D"monospace, monospace">sdn 21555</f=
ont></div><div style=3D"font-size:12.8px"><font face=3D"monospace, monospac=
e">sdo 21492</font></div><div style=3D"font-size:12.8px"><font face=3D"mono=
space, monospace">sdp 21677</font></div><div style=3D"font-size:12.8px"><fo=
nt face=3D"monospace, monospace">sdq 21717</font></div><div style=3D"font-s=
ize:12.8px"><font face=3D"monospace, monospace">sdr 21736</font></div><div =
style=3D"font-size:12.8px"><font face=3D"monospace, monospace">sds 21350</f=
ont></div><div style=3D"font-size:12.8px"><font face=3D"monospace, monospac=
e">sdt 21909</font></div><div style=3D"font-size:12.8px"><font face=3D"mono=
space, monospace">sdu 22082</font></div><div style=3D"font-size:12.8px"><fo=
nt face=3D"monospace, monospace">sdv 22148</font></div><div style=3D"font-s=
ize:12.8px"><font face=3D"monospace, monospace">sdw 21778</font></div><div =
style=3D"font-size:12.8px"><font face=3D"monospace, monospace">sdx 21380</f=
ont></div><div style=3D"font-size:12.8px"><font face=3D"monospace, monospac=
e">sdy 21770</font></div><div style=3D"font-size:12.8px"><font face=3D"mono=
space, monospace">sdz 21749</font></div><div style=3D"font-size:12.8px"><fo=
nt face=3D"monospace, monospace">sdaa 22161</font></div><div style=3D"font-=
size:12.8px"><font face=3D"monospace, monospace">sdab 21798</font></div><di=
v style=3D"font-size:12.8px"><font face=3D"monospace, monospace">sdac 21485=
</font></div><div style=3D"font-size:12.8px"><font face=3D"monospace, monos=
pace"><br></font></div><div style=3D"font-size:12.8px"><font face=3D"monosp=
ace, monospace">cln4:/home/hdd_test# date; ./disp_total_iops_512k.sh=C2=A0<=
/font></div><div style=3D"font-size:12.8px"><font face=3D"monospace, monosp=
ace">Thu Nov 19 10:13:33 PST 2015</font></div><div style=3D"font-size:12.8p=
x"><font face=3D"monospace, monospace">sdb 71328</font></div><div style=3D"=
font-size:12.8px"><font face=3D"monospace, monospace">sdc 71811</font></div=
><div style=3D"font-size:12.8px"><font face=3D"monospace, monospace">sdd 70=
860</font></div><div style=3D"font-size:12.8px"><font face=3D"monospace, mo=
nospace">sde 71680</font></div><div style=3D"font-size:12.8px"><font face=
=3D"monospace, monospace">sdf 71743</font></div><div style=3D"font-size:12.=
8px"><font face=3D"monospace, monospace">sdg 71171</font></div><div style=
=3D"font-size:12.8px"><font face=3D"monospace, monospace">sdh 71843</font><=
/div><div style=3D"font-size:12.8px"><font face=3D"monospace, monospace">sd=
i 71512</font></div><div style=3D"font-size:12.8px"><font face=3D"monospace=
, monospace">sdj 71328</font></div><div style=3D"font-size:12.8px"><font fa=
ce=3D"monospace, monospace">sdk 70977</font></div><div style=3D"font-size:1=
2.8px"><font face=3D"monospace, monospace">sdl 71614</font></div><div style=
=3D"font-size:12.8px"><font face=3D"monospace, monospace">sdm 70715</font><=
/div><div style=3D"font-size:12.8px"><font face=3D"monospace, monospace">sd=
n 70622</font></div><div style=3D"font-size:12.8px"><font face=3D"monospace=
, monospace">sdo 70424</font></div><div style=3D"font-size:12.8px"><font fa=
ce=3D"monospace, monospace">sdp 71338</font></div><div style=3D"font-size:1=
2.8px"><font face=3D"monospace, monospace">sdq 70990</font></div><div style=
=3D"font-size:12.8px"><font face=3D"monospace, monospace">sdr 71458</font><=
/div><div style=3D"font-size:12.8px"><font face=3D"monospace, monospace">sd=
s 70082</font></div><div style=3D"font-size:12.8px"><font face=3D"monospace=
, monospace">sdt 71995</font></div><div style=3D"font-size:12.8px"><font fa=
ce=3D"monospace, monospace">sdu 72433</font></div><div style=3D"font-size:1=
2.8px"><font face=3D"monospace, monospace">sdv 72504</font></div><div style=
=3D"font-size:12.8px"><font face=3D"monospace, monospace">sdw 71687</font><=
/div><div style=3D"font-size:12.8px"><font face=3D"monospace, monospace">sd=
x 70402</font></div><div style=3D"font-size:12.8px"><font face=3D"monospace=
, monospace">sdy 71299</font></div><div style=3D"font-size:12.8px"><font fa=
ce=3D"monospace, monospace">sdz 71376</font></div><div style=3D"font-size:1=
2.8px"><font face=3D"monospace, monospace">sdaa 72729</font></div><div styl=
e=3D"font-size:12.8px"><font face=3D"monospace, monospace">sdab 71302</font=
></div><div style=3D"font-size:12.8px"><font face=3D"monospace, monospace">=
sdac 70775</font></div><div style=3D"font-size:12.8px"><font face=3D"monosp=
ace, monospace"><br></font></div><div style=3D"font-size:12.8px"><font face=
=3D"monospace, monospace">cln4:/home/hdd_test# date; ./disp_total_iops_512k=
.sh=C2=A0</font></div><div style=3D"font-size:12.8px"><font face=3D"monospa=
ce, monospace">Thu Nov 19 10:22:25 PST 2015</font></div><div style=3D"font-=
size:12.8px"><font face=3D"monospace, monospace">sdb 177075</font></div><di=
v style=3D"font-size:12.8px"><font face=3D"monospace, monospace">sdc 178134=
</font></div><div style=3D"font-size:12.8px"><font face=3D"monospace, monos=
pace">sdd 176100</font></div><div style=3D"font-size:12.8px"><font face=3D"=
monospace, monospace">sde 178115</font></div><div style=3D"font-size:12.8px=
"><font face=3D"monospace, monospace">sdf 177950</font></div><div style=3D"=
font-size:12.8px"><font face=3D"monospace, monospace">sdg 176743</font></di=
v><div style=3D"font-size:12.8px"><font face=3D"monospace, monospace">sdh 1=
78478</font></div><div style=3D"font-size:12.8px"><font face=3D"monospace, =
monospace">sdi 177500</font></div><div style=3D"font-size:12.8px"><font fac=
e=3D"monospace, monospace">sdj 177239</font></div><div style=3D"font-size:1=
2.8px"><font face=3D"monospace, monospace">sdk 176294</font></div><div styl=
e=3D"font-size:12.8px"><font face=3D"monospace, monospace">sdl 177594</font=
></div><div style=3D"font-size:12.8px"><font face=3D"monospace, monospace">=
sdm 175325</font></div><div style=3D"font-size:12.8px"><font face=3D"monosp=
ace, monospace">sdn 175189</font></div><div style=3D"font-size:12.8px"><fon=
t face=3D"monospace, monospace">sdo 174962</font></div><div style=3D"font-s=
ize:12.8px"><font face=3D"monospace, monospace">sdp 177076</font></div><div=
 style=3D"font-size:12.8px"><font face=3D"monospace, monospace">sdq 176177<=
/font></div><div style=3D"font-size:12.8px"><font face=3D"monospace, monosp=
ace">sdr 177336</font></div><div style=3D"font-size:12.8px"><font face=3D"m=
onospace, monospace">sds 173842</font></div><div style=3D"font-size:12.8px"=
><font face=3D"monospace, monospace">sdt 178753</font></div><div style=3D"f=
ont-size:12.8px"><font face=3D"monospace, monospace">sdu 179514</font></div=
><div style=3D"font-size:12.8px"><font face=3D"monospace, monospace">sdv 17=
9681</font></div><div style=3D"font-size:12.8px"><font face=3D"monospace, m=
onospace">sdw 178229</font></div><div style=3D"font-size:12.8px"><font face=
=3D"monospace, monospace">sdx 174532</font></div><div style=3D"font-size:12=
.8px"><font face=3D"monospace, monospace">sdy 176912</font></div><div style=
=3D"font-size:12.8px"><font face=3D"monospace, monospace">sdz 176911</font>=
</div><div style=3D"font-size:12.8px"><font face=3D"monospace, monospace">s=
daa 180506</font></div><div style=3D"font-size:12.8px"><font face=3D"monosp=
ace, monospace">sdab 177070</font></div><div style=3D"font-size:12.8px"><fo=
nt face=3D"monospace, monospace">sdac 175550</font></div><div style=3D"font=
-size:12.8px"><font face=3D"monospace, monospace">cln4:/home/hdd_test# date=
; ./disp_total_iops_512k.sh=C2=A0</font></div><div style=3D"font-size:12.8p=
x"><font face=3D"monospace, monospace">Thu Nov 19 <span style=3D"background=
-color:rgb(255,255,0)">10:22:31</span> PST 2015 <span style=3D"background-c=
olor:rgb(255,255,0)">----&gt;&gt; SHOULD END HERE !!!!</span></font></div><=
div style=3D"font-size:12.8px"><font face=3D"monospace, monospace">sdb 1782=
04</font></div><div style=3D"font-size:12.8px"><font face=3D"monospace, mon=
ospace">sdc 179207</font></div><div style=3D"font-size:12.8px"><font face=
=3D"monospace, monospace">sdd 177169</font></div><div style=3D"font-size:12=
.8px"><font face=3D"monospace, monospace">sde 179235</font></div><div style=
=3D"font-size:12.8px"><font face=3D"monospace, monospace">sdf 179028</font>=
</div><div style=3D"font-size:12.8px"><font face=3D"monospace, monospace">s=
dg 177822</font></div><div style=3D"font-size:12.8px"><font face=3D"monospa=
ce, monospace">sdh 179602</font></div><div style=3D"font-size:12.8px"><font=
 face=3D"monospace, monospace">sdi 178644</font></div><div style=3D"font-si=
ze:12.8px"><font face=3D"monospace, monospace">sdj 178364</font></div><div =
style=3D"font-size:12.8px"><font face=3D"monospace, monospace">sdk 177397</=
font></div><div style=3D"font-size:12.8px"><font face=3D"monospace, monospa=
ce">sdl 178707</font></div><div style=3D"font-size:12.8px"><font face=3D"mo=
nospace, monospace">sdm 176411</font></div><div style=3D"font-size:12.8px">=
<font face=3D"monospace, monospace">sdn 176273</font></div><div style=3D"fo=
nt-size:12.8px"><font face=3D"monospace, monospace">sdo 176054</font></div>=
<div style=3D"font-size:12.8px"><font face=3D"monospace, monospace">sdp 178=
182</font></div><div style=3D"font-size:12.8px"><font face=3D"monospace, mo=
nospace">sdq 177258</font></div><div style=3D"font-size:12.8px"><font face=
=3D"monospace, monospace">sdr 178428</font></div><div style=3D"font-size:12=
.8px"><font face=3D"monospace, monospace">sds 174951</font></div><div style=
=3D"font-size:12.8px"><font face=3D"monospace, monospace">sdt 179844</font>=
</div><div style=3D"font-size:12.8px"><font face=3D"monospace, monospace">s=
du 180614</font></div><div style=3D"font-size:12.8px"><font face=3D"monospa=
ce, monospace">sdv 180792</font></div><div style=3D"font-size:12.8px"><font=
 face=3D"monospace, monospace">sdw 179292</font></div><div style=3D"font-si=
ze:12.8px"><font face=3D"monospace, monospace">sdx 175625</font></div><div =
style=3D"font-size:12.8px"><font face=3D"monospace, monospace">sdy 178005</=
font></div><div style=3D"font-size:12.8px"><font face=3D"monospace, monospa=
ce">sdz 177983</font></div><div style=3D"font-size:12.8px"><font face=3D"mo=
nospace, monospace">sdaa 181612</font></div><div style=3D"font-size:12.8px"=
><font face=3D"monospace, monospace">sdab 178120</font></div><div style=3D"=
font-size:12.8px"><font face=3D"monospace, monospace">sdac 176646</font></d=
iv><span class=3D"im" style=3D"font-size:12.8px"><div><font face=3D"monospa=
ce, monospace"><br></font></div><div><font face=3D"monospace, monospace">De=
vice: =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0tps =C2=A0 =C2=A0kB_read/s =
=C2=A0 =C2=A0kB_wrtn/s =C2=A0 =C2=A0kB_read =C2=A0 =C2=A0kB_wrtn</font></di=
v></span><div style=3D"font-size:12.8px"><font face=3D"monospace, monospace=
">sda =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A041.50 =C2=A0 =C2=A0 =
=C2=A01678.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 3356 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00</font></div><div style=3D"font-size:12.=
8px"><font face=3D"monospace, monospace">sdb =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 170.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 87040.0=
0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 174080</font></div><div=
 style=3D"font-size:12.8px"><font face=3D"monospace, monospace">sdc =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 186.50 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =
=C2=A0 =C2=A0 95488.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 19=
0976</font></div><div style=3D"font-size:12.8px"><font face=3D"monospace, m=
onospace">sdd =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 210.00 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0107520.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A00 =C2=A0 =C2=A0 215040</font></div><span class=3D"im" style=3D"font-s=
ize:12.8px"><div><font face=3D"monospace, monospace">sde =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A00</font></div><div><font face=3D"monospace, mono=
space">sdf =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00</font></div><div><fo=
nt face=3D"monospace, monospace">sdg =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A00</font></div></span><div style=3D"font-size:12.8px"><font face=3D"mo=
nospace, monospace">sdh =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 221.00 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0113152.00 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 226304</font></div><div style=3D"font-size=
:12.8px"><font face=3D"monospace, monospace">sdi =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 208.50 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A01067=
52.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 213504</font></div>=
<div style=3D"font-size:12.8px"><font face=3D"monospace, monospace">sdj =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 201.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0=
.00 =C2=A0 =C2=A0102912.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=
=A0 205824</font></div><div style=3D"font-size:12.8px"><font face=3D"monosp=
ace, monospace">sdk =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 209.50 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0107264.00 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A00 =C2=A0 =C2=A0 214528</font></div><div style=3D"font-size:12.8px=
"><font face=3D"monospace, monospace">sdl =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 204.50 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0104704.00 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 209408</font></div><div s=
tyle=3D"font-size:12.8px"><font face=3D"monospace, monospace">sdm =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 206.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =
=C2=A0 =C2=A0105472.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 21=
0944</font></div><span class=3D"im" style=3D"font-size:12.8px"><font face=
=3D"monospace, monospace">sdn =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00</fo=
nt></span><div style=3D"font-size:12.8px"><font face=3D"monospace, monospac=
e">sdo =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00</font></div><div style=
=3D"font-size:12.8px"><font face=3D"monospace, monospace">sdp =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A00</font></div><div style=3D"font-size:12.8px"><=
font face=3D"monospace, monospace">sdq =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A00</font></div><div style=3D"font-size:12.8px"><font face=3D"monospac=
e, monospace">sdr =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 194.50 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 99584.00 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A00 =C2=A0 =C2=A0 199168</font></div><div style=3D"font-size:12.8px=
"><font face=3D"monospace, monospace">sds =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 192.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 98304.00 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 196608</font></div><div s=
tyle=3D"font-size:12.8px"><font face=3D"monospace, monospace">sdt =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 198.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =
=C2=A0 =C2=A0101376.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 20=
2752</font></div><div style=3D"font-size:12.8px"><font face=3D"monospace, m=
onospace">sdu =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00</font></div><div =
style=3D"font-size:12.8px"><font face=3D"monospace, monospace">sdv =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00</font></div><div style=3D"font-size:12.=
8px"><font face=3D"monospace, monospace">sdw =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A00</font></div><div style=3D"font-size:12.8px"><font face=3D"m=
onospace, monospace">sdx =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 211.00 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0108032.00 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 216064</font></div><div style=3D"font-size=
:12.8px"><font face=3D"monospace, monospace">sdy =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 205.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A01049=
60.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 209920</font></div>=
<div style=3D"font-size:12.8px"><font face=3D"monospace, monospace">sdz =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00</font></div><div style=3D"font-siz=
e:12.8px"><font face=3D"monospace, monospace">sdaa =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A00.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A00</font></div><div style=3D"font-size:12.8px"><font face=
=3D"monospace, monospace">sdab =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0205=
.50 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0105216.00 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 210432</font></div><div style=3D"font-s=
ize:12.8px"><font face=3D"monospace, monospace">sdac =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A00.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A00</font></div><span class=3D"im" style=3D"font-size:12.=
8px"><div><font face=3D"monospace, monospace"><br></font></div><div><font f=
ace=3D"monospace, monospace"><br></font></div><div><font face=3D"monospace,=
 monospace">Device: =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0tps =C2=A0 =C2=
=A0kB_read/s =C2=A0 =C2=A0kB_wrtn/s =C2=A0 =C2=A0kB_read =C2=A0 =C2=A0kB_wr=
tn</font></div></span><div style=3D"font-size:12.8px"><font face=3D"monospa=
ce, monospace">sda =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A055.50 =
=C2=A0 =C2=A0 =C2=A01842.00 =C2=A0 =C2=A0 =C2=A0 =C2=A032.00 =C2=A0 =C2=A0 =
=C2=A0 3684 =C2=A0 =C2=A0 =C2=A0 =C2=A0 64</font></div><div style=3D"font-s=
ize:12.8px"><font face=3D"monospace, monospace">sdb =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 186.50 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =
95488.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 190976</font></d=
iv><span class=3D"im" style=3D"font-size:12.8px"><font face=3D"monospace, m=
onospace">sdc =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00</font></span><div=
 style=3D"font-size:12.8px"><font face=3D"monospace, monospace">sdd =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 212.50 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =
=C2=A0 =C2=A0108800.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 21=
7600</font></div><span class=3D"im" style=3D"font-size:12.8px"><div><font f=
ace=3D"monospace, monospace">sde =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.=
00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00<=
/font></div><div><font face=3D"monospace, monospace">sdf =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A00</font></div><div><font face=3D"monospace, mono=
space">sdg =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00</font></div></span><=
span class=3D"im" style=3D"font-size:12.8px"><font face=3D"monospace, monos=
pace">sdh =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 217.00 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0111104.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A00 =C2=A0 =C2=A0 222208</font></span><div style=3D"font-size:12.8px"><fon=
t face=3D"monospace, monospace">sdi =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 206.50 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0105728.00 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 211456</font></div><div style=3D=
"font-size:12.8px"><font face=3D"monospace, monospace">sdj =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 195.50 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =
=C2=A0100096.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 200192</f=
ont></div><span class=3D"im" style=3D"font-size:12.8px"><font face=3D"monos=
pace, monospace">sdk =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 201.00 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0102912.00 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A00 =C2=A0 =C2=A0 205824</font></span><div style=3D"font-size:12=
.8px"><font face=3D"monospace, monospace">sdl =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 199.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0101888.0=
0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 203776</font></div><spa=
n class=3D"im" style=3D"font-size:12.8px"><div><font face=3D"monospace, mon=
ospace">sdm =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00</font></div><div>=
<font face=3D"monospace, monospace">sdn =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A00</font></div></span><div style=3D"font-size:12.8px"><font face=3D"m=
onospace, monospace">sdo =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0=
.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00</font>=
</div><div style=3D"font-size:12.8px"><font face=3D"monospace, monospace">s=
dp =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00</font></div><div style=3D"f=
ont-size:12.8px"><font face=3D"monospace, monospace">sdq =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A00</font></div><div style=3D"font-size:12.8px"><f=
ont face=3D"monospace, monospace">sdr =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 181.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 92672.00 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 185344</font></div><div styl=
e=3D"font-size:12.8px"><font face=3D"monospace, monospace">sds =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 192.50 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=
=A0 =C2=A0 98560.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 19712=
0</font></div><div style=3D"font-size:12.8px"><font face=3D"monospace, mono=
space">sdt =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 207.50 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0106240.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A00 =C2=A0 =C2=A0 212480</font></div><div style=3D"font-size:12.8px"><font=
 face=3D"monospace, monospace">sdu =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A00</font></div><div style=3D"font-size:12.8px"><font face=3D"monospace=
, monospace">sdv =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00</font></div><=
div style=3D"font-size:12.8px"><font face=3D"monospace, monospace">sdw =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00</font></div><div style=3D"font-siz=
e:12.8px"><font face=3D"monospace, monospace">sdx =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 211.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A01080=
32.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 216064</font></div>=
<div style=3D"font-size:12.8px"><font face=3D"monospace, monospace">sdy =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 190.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0=
.00 =C2=A0 =C2=A0 97280.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=
=A0 194560</font></div><div style=3D"font-size:12.8px"><font face=3D"monosp=
ace, monospace">sdz =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00</font></di=
v><div style=3D"font-size:12.8px"><font face=3D"monospace, monospace">sdaa =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00.00 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00</font></div><div style=3D"font-=
size:12.8px"><font face=3D"monospace, monospace">sdab =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0202.50 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A010=
3680.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 207360</font></di=
v><div style=3D"font-size:12.8px"><font face=3D"monospace, monospace">sdac =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00.00 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00</font></div><div style=3D"font-=
size:12.8px"><font face=3D"monospace, monospace"><br></font></div><div styl=
e=3D"font-size:12.8px"><font face=3D"monospace, monospace"><br></font></div=
><div style=3D"font-size:12.8px"><font face=3D"monospace, monospace"><br></=
font></div><div style=3D"font-size:12.8px"><font face=3D"monospace, monospa=
ce">cln4:/home/hdd_test# date; ./disp_total_iops_512k.sh=C2=A0</font></div>=
<div style=3D"font-size:12.8px"><font face=3D"monospace, monospace">Thu Nov=
 19 10:23:12 PST 2015</font></div><div style=3D"font-size:12.8px"><font fac=
e=3D"monospace, monospace">sdb 186323</font></div><div style=3D"font-size:1=
2.8px"><font face=3D"monospace, monospace">sdc 183418</font></div><div styl=
e=3D"font-size:12.8px"><font face=3D"monospace, monospace">sdd 185207</font=
></div><div style=3D"font-size:12.8px"><font face=3D"monospace, monospace">=
sde 182338</font></div><div style=3D"font-size:12.8px"><font face=3D"monosp=
ace, monospace">sdf 182166</font></div><div style=3D"font-size:12.8px"><fon=
t face=3D"monospace, monospace">sdg 181010</font></div><div style=3D"font-s=
ize:12.8px"><font face=3D"monospace, monospace">sdh 187822</font></div><div=
 style=3D"font-size:12.8px"><font face=3D"monospace, monospace">sdi 186776<=
/font></div><div style=3D"font-size:12.8px"><font face=3D"monospace, monosp=
ace">sdj 186457</font></div><div style=3D"font-size:12.8px"><font face=3D"m=
onospace, monospace">sdk 184790</font></div><div style=3D"font-size:12.8px"=
><font face=3D"monospace, monospace">sdl 186859</font></div><div style=3D"f=
ont-size:12.8px"><font face=3D"monospace, monospace">sdm 181900</font></div=
><div style=3D"font-size:12.8px"><font face=3D"monospace, monospace">sdn 17=
9394</font></div><div style=3D"font-size:12.8px"><font face=3D"monospace, m=
onospace">sdo 179228</font></div><div style=3D"font-size:12.8px"><font face=
=3D"monospace, monospace">sdp 181386</font></div><div style=3D"font-size:12=
.8px"><font face=3D"monospace, monospace">sdq 180374</font></div><div style=
=3D"font-size:12.8px"><font face=3D"monospace, monospace">sdr 186584</font>=
</div><div style=3D"font-size:12.8px"><font face=3D"monospace, monospace">s=
ds 181994</font></div><div style=3D"font-size:12.8px"><font face=3D"monospa=
ce, monospace">sdt 188087</font></div><div style=3D"font-size:12.8px"><font=
 face=3D"monospace, monospace">sdu 183868</font></div><div style=3D"font-si=
ze:12.8px"><font face=3D"monospace, monospace">sdv 183976</font></div><div =
style=3D"font-size:12.8px"><font face=3D"monospace, monospace">sdw 182562</=
font></div><div style=3D"font-size:12.8px"><font face=3D"monospace, monospa=
ce">sdx 183664</font></div><div style=3D"font-size:12.8px"><font face=3D"mo=
nospace, monospace">sdy 186096</font></div><div style=3D"font-size:12.8px">=
<font face=3D"monospace, monospace">sdz 181240</font></div><div style=3D"fo=
nt-size:12.8px"><font face=3D"monospace, monospace">sdaa 184892</font></div=
><div style=3D"font-size:12.8px"><font face=3D"monospace, monospace">sdab 1=
86197</font></div><div style=3D"font-size:12.8px"><font face=3D"monospace, =
monospace">sdac 179804</font></div><span class=3D"im" style=3D"font-size:12=
.8px"><div><font face=3D"monospace, monospace"><br></font></div><div><font =
face=3D"monospace, monospace">Device: =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0tps =C2=A0 =C2=A0kB_read/s =C2=A0 =C2=A0kB_wrtn/s =C2=A0 =C2=A0kB_rea=
d =C2=A0 =C2=A0kB_wrtn</font></div></span><div style=3D"font-size:12.8px"><=
font face=3D"monospace, monospace">sda =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A017.00 =C2=A0 =C2=A0 =C2=A0 362.00 =C2=A0 =C2=A0 =C2=A0 =C2=A05=
6.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0724 =C2=A0 =C2=A0 =C2=A0 =C2=A0112</font></=
div><div style=3D"font-size:12.8px"><font face=3D"monospace, monospace">sdb=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 207.50 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 0.00 =C2=A0 =C2=A0106240.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 =
=C2=A0 212480</font></div><span class=3D"im" style=3D"font-size:12.8px"><fo=
nt face=3D"monospace, monospace">sdc =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A00</font></span><div style=3D"font-size:12.8px"><font face=3D"monospac=
e, monospace">sdd =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 190.50 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 97536.00 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A00 =C2=A0 =C2=A0 195072</font></div><span class=3D"im" style=3D"fo=
nt-size:12.8px"><div><font face=3D"monospace, monospace">sde =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A00</font></div><div><font face=3D"monospace, mon=
ospace">sdf =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00</font></div><div>=
<font face=3D"monospace, monospace">sdg =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A00</font></div></span><div style=3D"font-size:12.8px"><font face=3D"m=
onospace, monospace">sdh =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 189.50 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 97024.00 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 194048</font></div><span class=3D"im" styl=
e=3D"font-size:12.8px"><font face=3D"monospace, monospace">sdi =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.0=
0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00</font></span><div style=3D"font-size:12.8p=
x"><font face=3D"monospace, monospace">sdj =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 208.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0106496.00 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 212992</font></div><span =
class=3D"im" style=3D"font-size:12.8px"><font face=3D"monospace, monospace"=
>sdk =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00</font></span><div style=
=3D"font-size:12.8px"><font face=3D"monospace, monospace">sdl =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 195.50 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0=
 =C2=A0100096.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 200192</=
font></div><span class=3D"im" style=3D"font-size:12.8px"><div><font face=3D=
"monospace, monospace">sdm =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00</font>=
</div><div><font face=3D"monospace, monospace">sdn =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A00</font></div></span><div style=3D"font-size:12.8px"><f=
ont face=3D"monospace, monospace">sdo =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A00</font></div><div style=3D"font-size:12.8px"><font face=3D"monospac=
e, monospace">sdp =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00</font></div><=
div style=3D"font-size:12.8px"><font face=3D"monospace, monospace">sdq =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00</font></div><div style=3D"font-siz=
e:12.8px"><font face=3D"monospace, monospace">sdr =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 213.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A01090=
56.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 218112</font></div>=
<div style=3D"font-size:12.8px"><font face=3D"monospace, monospace">sds =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00</font></div><div style=3D"font-siz=
e:12.8px"><font face=3D"monospace, monospace">sdt =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 208.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A01064=
96.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 212992</font></div>=
<div style=3D"font-size:12.8px"><font face=3D"monospace, monospace">sdu =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00</font></div><div style=3D"font-siz=
e:12.8px"><font face=3D"monospace, monospace">sdv =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A00</font></div><div style=3D"font-size:12.8px"><font fac=
e=3D"monospace, monospace">sdw =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.=
00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00<=
/font></div><div style=3D"font-size:12.8px"><font face=3D"monospace, monosp=
ace">sdx =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 199.50 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 0.00 =C2=A0 =C2=A0102144.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =
=C2=A0 =C2=A0 204288</font></div><div style=3D"font-size:12.8px"><font face=
=3D"monospace, monospace">sdy =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 189=
.50 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 97024.00 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 194048</font></div><div style=3D"font-s=
ize:12.8px"><font face=3D"monospace, monospace">sdz =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A00</font></div><div style=3D"font-size:12.8px"><font fa=
ce=3D"monospace, monospace">sdaa =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A00.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.0=
0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00</=
font></div><div style=3D"font-size:12.8px"><font face=3D"monospace, monospa=
ce">sdab =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0215.00 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 0.00 =C2=A0 =C2=A0110080.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =
=C2=A0 =C2=A0 220160</font></div><div style=3D"font-size:12.8px"><font face=
=3D"monospace, monospace">sdac =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A00.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.0=
0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00</=
font></div><div style=3D"font-size:12.8px"><font face=3D"monospace, monospa=
ce"><br></font></div><div style=3D"font-size:12.8px"><font face=3D"monospac=
e, monospace">cln4:/home/hdd_test# date; ./disp_total_iops_512k.sh=C2=A0</f=
ont></div><div style=3D"font-size:12.8px"><font face=3D"monospace, monospac=
e">Thu Nov 19 10:23:29 PST 2015</font></div><div style=3D"font-size:12.8px"=
><font face=3D"monospace, monospace">sdb 189869</font></div><div style=3D"f=
ont-size:12.8px"><font face=3D"monospace, monospace">sdc 183418</font></div=
><div style=3D"font-size:12.8px"><font face=3D"monospace, monospace">sdd 18=
8716</font></div><div style=3D"font-size:12.8px"><font face=3D"monospace, m=
onospace">sde 182338</font></div><div style=3D"font-size:12.8px"><font face=
=3D"monospace, monospace">sdf 182166</font></div><div style=3D"font-size:12=
.8px"><font face=3D"monospace, monospace">sdg 181010</font></div><div style=
=3D"font-size:12.8px"><font face=3D"monospace, monospace">sdh 191382</font>=
</div><div style=3D"font-size:12.8px"><font face=3D"monospace, monospace">s=
di 187256</font></div><div style=3D"font-size:12.8px"><font face=3D"monospa=
ce, monospace">sdj 190025</font></div><div style=3D"font-size:12.8px"><font=
 face=3D"monospace, monospace">sdk 184790</font></div><div style=3D"font-si=
ze:12.8px"><font face=3D"monospace, monospace">sdl 190415</font></div><div =
style=3D"font-size:12.8px"><font face=3D"monospace, monospace">sdm 181900</=
font></div><div style=3D"font-size:12.8px"><font face=3D"monospace, monospa=
ce">sdn 179394</font></div><div style=3D"font-size:12.8px"><font face=3D"mo=
nospace, monospace">sdo 179228</font></div><div style=3D"font-size:12.8px">=
<font face=3D"monospace, monospace">sdp 181386</font></div><div style=3D"fo=
nt-size:12.8px"><font face=3D"monospace, monospace">sdq 180374</font></div>=
<div style=3D"font-size:12.8px"><font face=3D"monospace, monospace">sdr 190=
136</font></div><div style=3D"font-size:12.8px"><font face=3D"monospace, mo=
nospace">sds 181994</font></div><div style=3D"font-size:12.8px"><font face=
=3D"monospace, monospace">sdt 191684</font></div><div style=3D"font-size:12=
.8px"><font face=3D"monospace, monospace">sdu 183868</font></div><div style=
=3D"font-size:12.8px"><font face=3D"monospace, monospace">sdv 183976</font>=
</div><div style=3D"font-size:12.8px"><font face=3D"monospace, monospace">s=
dw 182562</font></div><div style=3D"font-size:12.8px"><font face=3D"monospa=
ce, monospace">sdx 187147</font></div><div style=3D"font-size:12.8px"><font=
 face=3D"monospace, monospace">sdy 189641</font></div><div style=3D"font-si=
ze:12.8px"><font face=3D"monospace, monospace">sdz 181240</font></div><div =
style=3D"font-size:12.8px"><font face=3D"monospace, monospace">sdaa 184892<=
/font></div><div style=3D"font-size:12.8px"><font face=3D"monospace, monosp=
ace">sdab 189731</font></div><div style=3D"font-size:12.8px"><font face=3D"=
monospace, monospace">sdac 179804</font></div><span class=3D"im" style=3D"f=
ont-size:12.8px"><div><font face=3D"monospace, monospace"><br></font></div>=
<div><font face=3D"monospace, monospace">Device: =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0tps =C2=A0 =C2=A0kB_read/s =C2=A0 =C2=A0kB_wrtn/s =C2=A0 =
=C2=A0kB_read =C2=A0 =C2=A0kB_wrtn</font></div></span><div style=3D"font-si=
ze:12.8px"><font face=3D"monospace, monospace">sda =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A041.50 =C2=A0 =C2=A0 =C2=A01712.00 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 3424 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A00</font></div><div style=3D"font-size:12.8px"><font face=3D"monospace, m=
onospace">sdb =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 206.00 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0105472.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A00 =C2=A0 =C2=A0 210944</font></div><span class=3D"im" style=3D"font-s=
ize:12.8px"><font face=3D"monospace, monospace">sdc =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A00</font></span><div style=3D"font-size:12.8px"><font f=
ace=3D"monospace, monospace">sdd =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
198.50 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0101632.00 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 203264</font></div><span class=3D"i=
m" style=3D"font-size:12.8px"><div><font face=3D"monospace, monospace">sde =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00</font></div><div><font face=3D"=
monospace, monospace">sdf =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00</font>=
</div><div><font face=3D"monospace, monospace">sdg =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A00</font></div></span><div style=3D"font-size:12.8px"><f=
ont face=3D"monospace, monospace">sdh =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 189.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 96768.00 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 193536</font></div><span cla=
ss=3D"im" style=3D"font-size:12.8px"><font face=3D"monospace, monospace">sd=
i =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00</font></span><div style=3D"=
font-size:12.8px"><font face=3D"monospace, monospace">sdj =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 199.50 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=
=A0102144.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 204288</font=
></div><span class=3D"im" style=3D"font-size:12.8px"><font face=3D"monospac=
e, monospace">sdk =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00</font></span>=
<div style=3D"font-size:12.8px"><font face=3D"monospace, monospace">sdl =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 203.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0=
.00 =C2=A0 =C2=A0103936.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=
=A0 207872</font></div><span class=3D"im" style=3D"font-size:12.8px"><div><=
font face=3D"monospace, monospace">sdm =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A00</font></div><div><font face=3D"monospace, monospace">sdn =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00</font></div></span><div style=3D"font-s=
ize:12.8px"><font face=3D"monospace, monospace">sdo =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A00</font></div><div style=3D"font-size:12.8px"><font fa=
ce=3D"monospace, monospace">sdp =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.=
00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00<=
/font></div><div style=3D"font-size:12.8px"><font face=3D"monospace, monosp=
ace">sdq =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00</font></div><div sty=
le=3D"font-size:12.8px"><font face=3D"monospace, monospace">sdr =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 201.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=
=A0 =C2=A0102912.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 20582=
4</font></div><div style=3D"font-size:12.8px"><font face=3D"monospace, mono=
space">sds =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00</font></div><div sty=
le=3D"font-size:12.8px"><font face=3D"monospace, monospace">sdt =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 195.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=
=A0 =C2=A0 99840.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 19968=
0</font></div><div style=3D"font-size:12.8px"><font face=3D"monospace, mono=
space">sdu =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00</font></div><div sty=
le=3D"font-size:12.8px"><font face=3D"monospace, monospace">sdv =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.0=
0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00</font></div><div style=3D"font-size:12.8px=
"><font face=3D"monospace, monospace">sdw =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A00</font></div><div style=3D"font-size:12.8px"><font face=3D"mo=
nospace, monospace">sdx =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 202.00 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0103424.00 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 206848</font></div><div style=3D"font-size=
:12.8px"><font face=3D"monospace, monospace">sdy =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A031.50 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=
=A0 16128.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 =C2=A032256<=
/font></div><div style=3D"font-size:12.8px"><font face=3D"monospace, monosp=
ace">sdz =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00</font></div><div sty=
le=3D"font-size:12.8px"><font face=3D"monospace, monospace">sdaa =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00</font></div><div style=3D"font-size:12.8px=
"><font face=3D"monospace, monospace">sdab =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A00.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A00</font></div><div style=3D"font-size:12.8px"><font face=3D"monos=
pace, monospace">sdac =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00.00 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00</font></di=
v><div style=3D"font-size:12.8px"><font face=3D"monospace, monospace"><br><=
/font></div><div style=3D"font-size:12.8px"><font face=3D"monospace, monosp=
ace">cln4:/home/hdd_test# date; ./disp_total_iops_512k.sh=C2=A0</font></div=
><div style=3D"font-size:12.8px"><font face=3D"monospace, monospace">Thu No=
v 19 10:23:55 PST 2015</font></div><div style=3D"font-size:12.8px"><font fa=
ce=3D"monospace, monospace">sdb 194927</font></div><div style=3D"font-size:=
12.8px"><font face=3D"monospace, monospace">sdc 183418</font></div><div sty=
le=3D"font-size:12.8px"><font face=3D"monospace, monospace">sdd 193720</fon=
t></div><div style=3D"font-size:12.8px"><font face=3D"monospace, monospace"=
>sde 182338</font></div><div style=3D"font-size:12.8px"><font face=3D"monos=
pace, monospace">sdf 182166</font></div><div style=3D"font-size:12.8px"><fo=
nt face=3D"monospace, monospace">sdg 181010</font></div><div style=3D"font-=
size:12.8px"><font face=3D"monospace, monospace">sdh 196466</font></div><di=
v style=3D"font-size:12.8px"><font face=3D"monospace, monospace">sdi 187256=
</font></div><div style=3D"font-size:12.8px"><font face=3D"monospace, monos=
pace">sdj 195111</font></div><div style=3D"font-size:12.8px"><font face=3D"=
monospace, monospace">sdk 184790</font></div><div style=3D"font-size:12.8px=
"><font face=3D"monospace, monospace">sdl 195463</font></div><div style=3D"=
font-size:12.8px"><font face=3D"monospace, monospace">sdm 181900</font></di=
v><div style=3D"font-size:12.8px"><font face=3D"monospace, monospace">sdn 1=
79394</font></div><div style=3D"font-size:12.8px"><font face=3D"monospace, =
monospace">sdo 179228</font></div><div style=3D"font-size:12.8px"><font fac=
e=3D"monospace, monospace">sdp 181386</font></div><div style=3D"font-size:1=
2.8px"><font face=3D"monospace, monospace">sdq 180374</font></div><div styl=
e=3D"font-size:12.8px"><font face=3D"monospace, monospace">sdr 195167</font=
></div><div style=3D"font-size:12.8px"><font face=3D"monospace, monospace">=
sds 181994</font></div><div style=3D"font-size:12.8px"><font face=3D"monosp=
ace, monospace">sdt 196775</font></div><div style=3D"font-size:12.8px"><fon=
t face=3D"monospace, monospace">sdu 183868</font></div><div style=3D"font-s=
ize:12.8px"><font face=3D"monospace, monospace">sdv 183976</font></div><div=
 style=3D"font-size:12.8px"><font face=3D"monospace, monospace">sdw 182562<=
/font></div><div style=3D"font-size:12.8px"><font face=3D"monospace, monosp=
ace">sdx 192105</font></div><div style=3D"font-size:12.8px"><font face=3D"m=
onospace, monospace">sdy 192874</font></div><div style=3D"font-size:12.8px"=
><font face=3D"monospace, monospace">sdz 181240</font></div><div style=3D"f=
ont-size:12.8px"><font face=3D"monospace, monospace">sdaa 184892</font></di=
v><div style=3D"font-size:12.8px"><font face=3D"monospace, monospace">sdab =
191350</font></div><div style=3D"font-size:12.8px"><font face=3D"monospace,=
 monospace">sdac 179804</font></div><span class=3D"im" style=3D"font-size:1=
2.8px"><div><font face=3D"monospace, monospace"><br></font></div><div><font=
 face=3D"monospace, monospace">Device: =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0tps =C2=A0 =C2=A0kB_read/s =C2=A0 =C2=A0kB_wrtn/s =C2=A0 =C2=A0kB_rea=
d =C2=A0 =C2=A0kB_wrtn</font></div></span><div style=3D"font-size:12.8px"><=
font face=3D"monospace, monospace">sda =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A061.50 =C2=A0 =C2=A0 =C2=A02086.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
0.00 =C2=A0 =C2=A0 =C2=A0 4172 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00</font></=
div><div style=3D"font-size:12.8px"><font face=3D"monospace, monospace">sdb=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 189.00 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 0.00 =C2=A0 =C2=A0 96768.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 =
=C2=A0 193536</font></div><span class=3D"im" style=3D"font-size:12.8px"><fo=
nt face=3D"monospace, monospace">sdc =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A00</font></span><div style=3D"font-size:12.8px"><font face=3D"monospac=
e, monospace">sdd =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 200.00 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0102400.00 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A00 =C2=A0 =C2=A0 204800</font></div><span class=3D"im" style=3D"fo=
nt-size:12.8px"><div><font face=3D"monospace, monospace">sde =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A00</font></div><div><font face=3D"monospace, mon=
ospace">sdf =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00</font></div><div>=
<font face=3D"monospace, monospace">sdg =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A00</font></div><div><font face=3D"monospace, monospace">sdh =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00</font></div><div><font face=3D"monospac=
e, monospace">sdi =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00</font></div><=
div><font face=3D"monospace, monospace">sdj =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A00</font></div><div><font face=3D"monospace, monospace">sdk =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00</font></div></span><div style=3D"f=
ont-size:12.8px"><font face=3D"monospace, monospace">sdl =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 184.50 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=
=A0 94464.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 188928</font=
></div><span class=3D"im" style=3D"font-size:12.8px"><div><font face=3D"mon=
ospace, monospace">sdm =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.0=
0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00</font></di=
v><div><font face=3D"monospace, monospace">sdn =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A00</font></div></span><div style=3D"font-size:12.8px"><font fa=
ce=3D"monospace, monospace">sdo =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.=
00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00<=
/font></div><div style=3D"font-size:12.8px"><font face=3D"monospace, monosp=
ace">sdp =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00</font></div><div sty=
le=3D"font-size:12.8px"><font face=3D"monospace, monospace">sdq =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.0=
0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00</font></div><div style=3D"font-size:12.8px=
"><font face=3D"monospace, monospace">sdr =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 215.50 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0110336.00 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 220672</font></div><div s=
tyle=3D"font-size:12.8px"><font face=3D"monospace, monospace">sds =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00</font></div><div style=3D"font-size:12.=
8px"><font face=3D"monospace, monospace">sdt =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 223.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0114176.0=
0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 228352</font></div><div=
 style=3D"font-size:12.8px"><font face=3D"monospace, monospace">sdu =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00</font></div><div style=3D"font-size:12.=
8px"><font face=3D"monospace, monospace">sdv =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A00</font></div><div style=3D"font-size:12.8px"><font face=3D"m=
onospace, monospace">sdw =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0=
.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00</font>=
</div><div style=3D"font-size:12.8px"><font face=3D"monospace, monospace">s=
dx =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 205.00 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 0.00 =C2=A0 =C2=A0104960.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=
=A0 =C2=A0 209920</font></div><div style=3D"font-size:12.8px"><font face=3D=
"monospace, monospace">sdy =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00</font>=
</div><div style=3D"font-size:12.8px"><font face=3D"monospace, monospace">s=
dz =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00</font></div><div style=3D"f=
ont-size:12.8px"><font face=3D"monospace, monospace">sdaa =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A00</font></div><div style=3D"font-size:12.8px"><font=
 face=3D"monospace, monospace">sdab =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A00.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A00</font></div><div style=3D"font-size:12.8px"><font face=3D"monospace, m=
onospace">sdac =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00.00 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00</font></div><div =
style=3D"font-size:12.8px"><font face=3D"monospace, monospace"><br></font><=
/div><div style=3D"font-size:12.8px"><font face=3D"monospace, monospace">cl=
n4:/home/hdd_test# date; ./disp_total_iops_512k.sh=C2=A0</font></div><div s=
tyle=3D"font-size:12.8px"><font face=3D"monospace, monospace">Thu Nov 19 10=
:24:36 PST 2015</font></div><div style=3D"font-size:12.8px"><font face=3D"m=
onospace, monospace">sdb 203100</font></div><div style=3D"font-size:12.8px"=
><font face=3D"monospace, monospace">sdc 183418</font></div><div style=3D"f=
ont-size:12.8px"><font face=3D"monospace, monospace">sdd 201814</font></div=
><div style=3D"font-size:12.8px"><font face=3D"monospace, monospace">sde 18=
2338</font></div><div style=3D"font-size:12.8px"><font face=3D"monospace, m=
onospace">sdf 182166</font></div><div style=3D"font-size:12.8px"><font face=
=3D"monospace, monospace">sdg 181010</font></div><div style=3D"font-size:12=
.8px"><font face=3D"monospace, monospace">sdh 201704</font></div><div style=
=3D"font-size:12.8px"><font face=3D"monospace, monospace">sdi 187256</font>=
</div><div style=3D"font-size:12.8px"><font face=3D"monospace, monospace">s=
dj 200326</font></div><div style=3D"font-size:12.8px"><font face=3D"monospa=
ce, monospace">sdk 184790</font></div><div style=3D"font-size:12.8px"><font=
 face=3D"monospace, monospace">sdl 203577</font></div><div style=3D"font-si=
ze:12.8px"><font face=3D"monospace, monospace">sdm 181900</font></div><div =
style=3D"font-size:12.8px"><font face=3D"monospace, monospace">sdn 179394</=
font></div><div style=3D"font-size:12.8px"><font face=3D"monospace, monospa=
ce">sdo 179228</font></div><div style=3D"font-size:12.8px"><font face=3D"mo=
nospace, monospace">sdp 181386</font></div><div style=3D"font-size:12.8px">=
<font face=3D"monospace, monospace">sdq 180374</font></div><div style=3D"fo=
nt-size:12.8px"><font face=3D"monospace, monospace">sdr 203330</font></div>=
<div style=3D"font-size:12.8px"><font face=3D"monospace, monospace">sds 181=
994</font></div><div style=3D"font-size:12.8px"><font face=3D"monospace, mo=
nospace">sdt 204983</font></div><div style=3D"font-size:12.8px"><font face=
=3D"monospace, monospace">sdu 183868</font></div><div style=3D"font-size:12=
.8px"><font face=3D"monospace, monospace">sdv 183976</font></div><div style=
=3D"font-size:12.8px"><font face=3D"monospace, monospace">sdw 182562</font>=
</div><div style=3D"font-size:12.8px"><font face=3D"monospace, monospace">s=
dx 200165</font></div><div style=3D"font-size:12.8px"><font face=3D"monospa=
ce, monospace">sdy 192874</font></div><div style=3D"font-size:12.8px"><font=
 face=3D"monospace, monospace">sdz 181240</font></div><div style=3D"font-si=
ze:12.8px"><font face=3D"monospace, monospace">sdaa 184892</font></div><div=
 style=3D"font-size:12.8px"><font face=3D"monospace, monospace">sdab 191350=
</font></div><div style=3D"font-size:12.8px"><font face=3D"monospace, monos=
pace">sdac 179804</font></div><span class=3D"im" style=3D"font-size:12.8px"=
><div><font face=3D"monospace, monospace"><br></font></div><div><font face=
=3D"monospace, monospace">Device: =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
tps =C2=A0 =C2=A0kB_read/s =C2=A0 =C2=A0kB_wrtn/s =C2=A0 =C2=A0kB_read =C2=
=A0 =C2=A0kB_wrtn</font></div></span><div style=3D"font-size:12.8px"><font =
face=3D"monospace, monospace">sda =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A018.50 =C2=A0 =C2=A0 =C2=A02060.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 8.00 =
=C2=A0 =C2=A0 =C2=A0 4120 =C2=A0 =C2=A0 =C2=A0 =C2=A0 16</font></div><span =
class=3D"im" style=3D"font-size:12.8px"><div><font face=3D"monospace, monos=
pace">sdb =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00</font></div><div><fo=
nt face=3D"monospace, monospace">sdc =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A00</font></div></span><div style=3D"font-size:12.8px"><font face=3D"mo=
nospace, monospace">sdd =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 204.50 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0104704.00 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 209408</font></div><span class=3D"im" styl=
e=3D"font-size:12.8px"><div><font face=3D"monospace, monospace">sde =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00</font></div><div><font face=3D"monospac=
e, monospace">sdf =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00</font></div><=
div><font face=3D"monospace, monospace">sdg =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A00</font></div><div><font face=3D"monospace, monospace">sdh =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00</font></div><div><font face=3D"mon=
ospace, monospace">sdi =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.0=
0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00</font></di=
v><div><font face=3D"monospace, monospace">sdj =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A00</font></div><div><font face=3D"monospace, monospace">sdk =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00</font></div></span><div style=
=3D"font-size:12.8px"><font face=3D"monospace, monospace">sdl =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 209.50 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0=
 =C2=A0107264.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 214528</=
font></div><span class=3D"im" style=3D"font-size:12.8px"><div><font face=3D=
"monospace, monospace">sdm =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00</font>=
</div><div><font face=3D"monospace, monospace">sdn =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A00</font></div></span><div style=3D"font-size:12.8px"><f=
ont face=3D"monospace, monospace">sdo =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A00</font></div><div style=3D"font-size:12.8px"><font face=3D"monospac=
e, monospace">sdp =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00</font></div><=
div style=3D"font-size:12.8px"><font face=3D"monospace, monospace">sdq =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00</font></div><div style=3D"font-siz=
e:12.8px"><font face=3D"monospace, monospace">sdr =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 208.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A01064=
96.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 212992</font></div>=
<div style=3D"font-size:12.8px"><font face=3D"monospace, monospace">sds =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00</font></div><div style=3D"font-siz=
e:12.8px"><font face=3D"monospace, monospace">sdt =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 210.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A01075=
20.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 215040</font></div>=
<div style=3D"font-size:12.8px"><font face=3D"monospace, monospace">sdu =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00</font></div><div style=3D"font-siz=
e:12.8px"><font face=3D"monospace, monospace">sdv =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A00</font></div><div style=3D"font-size:12.8px"><font fac=
e=3D"monospace, monospace">sdw =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.=
00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00<=
/font></div><div style=3D"font-size:12.8px"><font face=3D"monospace, monosp=
ace">sdx =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00</font></div><div sty=
le=3D"font-size:12.8px"><font face=3D"monospace, monospace">sdy =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.0=
0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00</font></div><div style=3D"font-size:12.8px=
"><font face=3D"monospace, monospace">sdz =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A00</font></div><div style=3D"font-size:12.8px"><font face=3D"mo=
nospace, monospace">sdaa =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00.=
00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00</font></d=
iv><div style=3D"font-size:12.8px"><font face=3D"monospace, monospace">sdab=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00.00 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00</font></div><div style=3D"font-=
size:12.8px"><font face=3D"monospace, monospace">sdac =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A00.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A00</font></div><div style=3D"font-size:12.8px"><font fac=
e=3D"monospace, monospace"><br></font></div><div style=3D"font-size:12.8px"=
><font face=3D"monospace, monospace">cln4:/home/hdd_test# date; ./disp_tota=
l_iops_512k.sh=C2=A0</font></div><div style=3D"font-size:12.8px"><font face=
=3D"monospace, monospace">Thu Nov 19 10:25:09 PST 2015</font></div><div sty=
le=3D"font-size:12.8px"><font face=3D"monospace, monospace">sdb 207564</fon=
t></div><div style=3D"font-size:12.8px"><font face=3D"monospace, monospace"=
>sdc 183418</font></div><div style=3D"font-size:12.8px"><font face=3D"monos=
pace, monospace">sdd 208503</font></div><div style=3D"font-size:12.8px"><fo=
nt face=3D"monospace, monospace">sde 182338</font></div><div style=3D"font-=
size:12.8px"><font face=3D"monospace, monospace">sdf 182166</font></div><di=
v style=3D"font-size:12.8px"><font face=3D"monospace, monospace">sdg 181010=
</font></div><div style=3D"font-size:12.8px"><font face=3D"monospace, monos=
pace">sdh 201704</font></div><div style=3D"font-size:12.8px"><font face=3D"=
monospace, monospace">sdi 187256</font></div><div style=3D"font-size:12.8px=
"><font face=3D"monospace, monospace">sdj 200326</font></div><div style=3D"=
font-size:12.8px"><font face=3D"monospace, monospace">sdk 184790</font></di=
v><div style=3D"font-size:12.8px"><font face=3D"monospace, monospace">sdl 2=
10362</font></div><div style=3D"font-size:12.8px"><font face=3D"monospace, =
monospace">sdm 181900</font></div><div style=3D"font-size:12.8px"><font fac=
e=3D"monospace, monospace">sdn 179394</font></div><div style=3D"font-size:1=
2.8px"><font face=3D"monospace, monospace">sdo 179228</font></div><div styl=
e=3D"font-size:12.8px"><font face=3D"monospace, monospace">sdp 181386</font=
></div><div style=3D"font-size:12.8px"><font face=3D"monospace, monospace">=
sdq 180374</font></div><div style=3D"font-size:12.8px"><font face=3D"monosp=
ace, monospace">sdr 210114</font></div><div style=3D"font-size:12.8px"><fon=
t face=3D"monospace, monospace">sds 181994</font></div><div style=3D"font-s=
ize:12.8px"><font face=3D"monospace, monospace">sdt 211744</font></div><div=
 style=3D"font-size:12.8px"><font face=3D"monospace, monospace">sdu 183868<=
/font></div><div style=3D"font-size:12.8px"><font face=3D"monospace, monosp=
ace">sdv 183976</font></div><div style=3D"font-size:12.8px"><font face=3D"m=
onospace, monospace">sdw 182562</font></div><div style=3D"font-size:12.8px"=
><font face=3D"monospace, monospace">sdx 201236</font></div><div style=3D"f=
ont-size:12.8px"><font face=3D"monospace, monospace">sdy 192874</font></div=
><div style=3D"font-size:12.8px"><font face=3D"monospace, monospace">sdz 18=
1240</font></div><div style=3D"font-size:12.8px"><font face=3D"monospace, m=
onospace">sdaa 184892</font></div><div style=3D"font-size:12.8px"><font fac=
e=3D"monospace, monospace">sdab 191350</font></div><div style=3D"font-size:=
12.8px"><font face=3D"monospace, monospace">sdac 179804</font></div><span c=
lass=3D"im" style=3D"font-size:12.8px"><div><font face=3D"monospace, monosp=
ace"><br></font></div><div><font face=3D"monospace, monospace">Device: =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0tps =C2=A0 =C2=A0kB_read/s =C2=A0 =C2=
=A0kB_wrtn/s =C2=A0 =C2=A0kB_read =C2=A0 =C2=A0kB_wrtn</font></div></span><=
div style=3D"font-size:12.8px"><font face=3D"monospace, monospace">sda =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A019.00 =C2=A0 =C2=A0 =C2=A02050=
.00 =C2=A0 =C2=A0 =C2=A0 =C2=A012.00 =C2=A0 =C2=A0 =C2=A0 4100 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 24</font></div><span class=3D"im" style=3D"font-size:12.8=
px"><div><font face=3D"monospace, monospace">sdb =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A00</font></div><div><font face=3D"monospace, monospace">=
sdc =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00</font></div></span><div sty=
le=3D"font-size:12.8px"><font face=3D"monospace, monospace">sdd =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 195.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=
=A0 =C2=A0 99840.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 19968=
0</font></div><span class=3D"im" style=3D"font-size:12.8px"><div><font face=
=3D"monospace, monospace">sde =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00</fo=
nt></div><div><font face=3D"monospace, monospace">sdf =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A00</font></div><div><font face=3D"monospace, monospace"=
>sdg =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00</font></div><div><font f=
ace=3D"monospace, monospace">sdh =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.=
00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00<=
/font></div><div><font face=3D"monospace, monospace">sdi =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A00</font></div><div><font face=3D"monospace, mono=
space">sdj =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00</font></div><div><fo=
nt face=3D"monospace, monospace">sdk =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A00</font></div></span><span class=3D"im" style=3D"font-size:12.8px"><f=
ont face=3D"monospace, monospace">sdl =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 197.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0100864.00 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 201728</font></span><span cl=
ass=3D"im" style=3D"font-size:12.8px"><div><font face=3D"monospace, monospa=
ce">sdm =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00</font></div><div><font f=
ace=3D"monospace, monospace">sdn =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.=
00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00<=
/font></div></span><div style=3D"font-size:12.8px"><font face=3D"monospace,=
 monospace">sdo =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00</font></div><=
div style=3D"font-size:12.8px"><font face=3D"monospace, monospace">sdp =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00</font></div><div style=3D"font-siz=
e:12.8px"><font face=3D"monospace, monospace">sdq =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A00</font></div><div style=3D"font-size:12.8px"><font fac=
e=3D"monospace, monospace">sdr =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 21=
2.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0108544.00 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 217088</font></div><div style=3D"font-s=
ize:12.8px"><font face=3D"monospace, monospace">sds =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A00</font></div><div style=3D"font-size:12.8px"><font fa=
ce=3D"monospace, monospace">sdt =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 1=
98.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0101376.00 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 202752</font></div><div style=3D"font-=
size:12.8px"><font face=3D"monospace, monospace">sdu =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A00</font></div><div style=3D"font-size:12.8px"><font fa=
ce=3D"monospace, monospace">sdv =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.=
00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00<=
/font></div><div style=3D"font-size:12.8px"><font face=3D"monospace, monosp=
ace">sdw =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00</font></div><div sty=
le=3D"font-size:12.8px"><font face=3D"monospace, monospace">sdx =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.0=
0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00</font></div><div style=3D"font-size:12.8px=
"><font face=3D"monospace, monospace">sdy =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A00</font></div><div style=3D"font-size:12.8px"><font face=3D"mo=
nospace, monospace">sdz =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.=
00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00</font></d=
iv><div style=3D"font-size:12.8px"><font face=3D"monospace, monospace">sdaa=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00.00 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00</font></div><div style=3D"font-=
size:12.8px"><font face=3D"monospace, monospace">sdab =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A00.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A00</font></div><div style=3D"font-size:12.8px"><font fac=
e=3D"monospace, monospace">sdac =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A00.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.0=
0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00</=
font></div><div style=3D"font-size:12.8px"><font face=3D"monospace, monospa=
ce"><br></font></div><div style=3D"font-size:12.8px"><font face=3D"monospac=
e, monospace"><br></font></div><div style=3D"font-size:12.8px"><font face=
=3D"monospace, monospace">cln4:/home/hdd_test# date; ./disp_total_iops_512k=
.sh=C2=A0</font></div><div style=3D"font-size:12.8px"><font face=3D"monospa=
ce, monospace">Thu Nov 19 10:26:12 PST 2015</font></div><div style=3D"font-=
size:12.8px"><font face=3D"monospace, monospace">sdb 207564</font></div><di=
v style=3D"font-size:12.8px"><font face=3D"monospace, monospace">sdc 183418=
</font></div><div style=3D"font-size:12.8px"><font face=3D"monospace, monos=
pace">sdd 220962</font></div><div style=3D"font-size:12.8px"><font face=3D"=
monospace, monospace">sde 182338</font></div><div style=3D"font-size:12.8px=
"><font face=3D"monospace, monospace">sdf 182166</font></div><div style=3D"=
font-size:12.8px"><font face=3D"monospace, monospace">sdg 181010</font></di=
v><div style=3D"font-size:12.8px"><font face=3D"monospace, monospace">sdh 2=
01704</font></div><div style=3D"font-size:12.8px"><font face=3D"monospace, =
monospace">sdi 187256</font></div><div style=3D"font-size:12.8px"><font fac=
e=3D"monospace, monospace">sdj 200326</font></div><div style=3D"font-size:1=
2.8px"><font face=3D"monospace, monospace">sdk 184790</font></div><div styl=
e=3D"font-size:12.8px"><font face=3D"monospace, monospace">sdl 222883</font=
></div><div style=3D"font-size:12.8px"><font face=3D"monospace, monospace">=
sdm 181900</font></div><div style=3D"font-size:12.8px"><font face=3D"monosp=
ace, monospace">sdn 179394</font></div><div style=3D"font-size:12.8px"><fon=
t face=3D"monospace, monospace">sdo 179228</font></div><div style=3D"font-s=
ize:12.8px"><font face=3D"monospace, monospace">sdp 181386</font></div><div=
 style=3D"font-size:12.8px"><font face=3D"monospace, monospace">sdq 180374<=
/font></div><div style=3D"font-size:12.8px"><font face=3D"monospace, monosp=
ace">sdr 222560</font></div><div style=3D"font-size:12.8px"><font face=3D"m=
onospace, monospace">sds 181994</font></div><div style=3D"font-size:12.8px"=
><font face=3D"monospace, monospace">sdt 224287</font></div><div style=3D"f=
ont-size:12.8px"><font face=3D"monospace, monospace">sdu 183868</font></div=
><div style=3D"font-size:12.8px"><font face=3D"monospace, monospace">sdv 18=
3976</font></div><div style=3D"font-size:12.8px"><font face=3D"monospace, m=
onospace">sdw 182562</font></div><div style=3D"font-size:12.8px"><font face=
=3D"monospace, monospace">sdx 201236</font></div><div style=3D"font-size:12=
.8px"><font face=3D"monospace, monospace">sdy 192874</font></div><div style=
=3D"font-size:12.8px"><font face=3D"monospace, monospace">sdz 181240</font>=
</div><div style=3D"font-size:12.8px"><font face=3D"monospace, monospace">s=
daa 184892</font></div><div style=3D"font-size:12.8px"><font face=3D"monosp=
ace, monospace">sdab 191350</font></div><div style=3D"font-size:12.8px"><fo=
nt face=3D"monospace, monospace">sdac 179804</font></div><span class=3D"im"=
 style=3D"font-size:12.8px"><div><font face=3D"monospace, monospace"><br></=
font></div><div><font face=3D"monospace, monospace"><br></font></div><div><=
font face=3D"monospace, monospace"><br></font></div><div><font face=3D"mono=
space, monospace"><br></font></div><div><font face=3D"monospace, monospace"=
>Device: =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0tps =C2=A0 =C2=A0kB_read/=
s =C2=A0 =C2=A0kB_wrtn/s =C2=A0 =C2=A0kB_read =C2=A0 =C2=A0kB_wrtn</font></=
div></span><div style=3D"font-size:12.8px"><font face=3D"monospace, monospa=
ce">sda =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A019.50 =C2=A0 =C2=A0=
 =C2=A02128.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 4256 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00</font></div><span class=3D"im" style=3D=
"font-size:12.8px"><div><font face=3D"monospace, monospace">sdb =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.0=
0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00</font></div><div><font face=3D"monospace, =
monospace">sdc =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00</font></div></spa=
n><div style=3D"font-size:12.8px"><font face=3D"monospace, monospace">sdd =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 219.00 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 0.00 =C2=A0 =C2=A0112128.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 =
=C2=A0 224256</font></div><span class=3D"im" style=3D"font-size:12.8px"><di=
v><font face=3D"monospace, monospace">sde =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A00</font></div><div><font face=3D"monospace, monospace">sdf =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00</font></div><div><font face=3D"mon=
ospace, monospace">sdg =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.0=
0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00</font></di=
v><div><font face=3D"monospace, monospace">sdh =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A00</font></div><div><font face=3D"monospace, monospace">sdi =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00</font></div><div><font face=3D"=
monospace, monospace">sdj =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00</font>=
</div><div><font face=3D"monospace, monospace">sdk =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A00</font></div><div><font face=3D"monospace, monospace">=
sdl =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00</font></div><div><font face=
=3D"monospace, monospace">sdm =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00</fo=
nt></div><div><font face=3D"monospace, monospace">sdn =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A00</font></div></span><div style=3D"font-size:12.8px"><=
font face=3D"monospace, monospace">sdo =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A00</font></div><div style=3D"font-size:12.8px"><font face=3D"monospac=
e, monospace">sdp =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00</font></div><=
div style=3D"font-size:12.8px"><font face=3D"monospace, monospace">sdq =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00</font></div><div style=3D"font-siz=
e:12.8px"><font face=3D"monospace, monospace">sdr =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 207.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A01059=
84.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 211968</font></div>=
<div style=3D"font-size:12.8px"><font face=3D"monospace, monospace">sds =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00</font></div><div style=3D"font-siz=
e:12.8px"><font face=3D"monospace, monospace">sdt =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 183.50 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 939=
52.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 187904</font></div>=
<div style=3D"font-size:12.8px"><font face=3D"monospace, monospace">sdu =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00</font></div><div style=3D"font-siz=
e:12.8px"><font face=3D"monospace, monospace">sdv =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A00</font></div><div style=3D"font-size:12.8px"><font fac=
e=3D"monospace, monospace">sdw =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.=
00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00<=
/font></div><div style=3D"font-size:12.8px"><font face=3D"monospace, monosp=
ace">sdx =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00</font></div><div sty=
le=3D"font-size:12.8px"><font face=3D"monospace, monospace">sdy =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.0=
0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00</font></div><div style=3D"font-size:12.8px=
"><font face=3D"monospace, monospace">sdz =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A00</font></div><div style=3D"font-size:12.8px"><font face=3D"mo=
nospace, monospace">sdaa =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00.=
00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00</font></d=
iv><div style=3D"font-size:12.8px"><font face=3D"monospace, monospace">sdab=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00.00 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00</font></div><div style=3D"font-=
size:12.8px"><font face=3D"monospace, monospace">sdac =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A00.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A00</font></div><div style=3D"font-size:12.8px"><font fac=
e=3D"monospace, monospace"><br></font></div><div style=3D"font-size:12.8px"=
><font face=3D"monospace, monospace">cln4:/home/hdd_test# date; ./disp_tota=
l_iops_512k.sh=C2=A0</font></div><div style=3D"font-size:12.8px"><font face=
=3D"monospace, monospace">Thu Nov 19 10:27:00 PST 2015</font></div><div sty=
le=3D"font-size:12.8px"><font face=3D"monospace, monospace">sdb 207564</fon=
t></div><div style=3D"font-size:12.8px"><font face=3D"monospace, monospace"=
>sdc 183418</font></div><div style=3D"font-size:12.8px"><font face=3D"monos=
pace, monospace">sdd 230499</font></div><div style=3D"font-size:12.8px"><fo=
nt face=3D"monospace, monospace">sde 182338</font></div><div style=3D"font-=
size:12.8px"><font face=3D"monospace, monospace">sdf 182166</font></div><di=
v style=3D"font-size:12.8px"><font face=3D"monospace, monospace">sdg 181010=
</font></div><div style=3D"font-size:12.8px"><font face=3D"monospace, monos=
pace">sdh 201704</font></div><div style=3D"font-size:12.8px"><font face=3D"=
monospace, monospace">sdi 187256</font></div><div style=3D"font-size:12.8px=
"><font face=3D"monospace, monospace">sdj 200326</font></div><div style=3D"=
font-size:12.8px"><font face=3D"monospace, monospace">sdk 184790</font></di=
v><div style=3D"font-size:12.8px"><font face=3D"monospace, monospace">sdl 2=
28202</font></div><div style=3D"font-size:12.8px"><font face=3D"monospace, =
monospace">sdm 181900</font></div><div style=3D"font-size:12.8px"><font fac=
e=3D"monospace, monospace">sdn 179394</font></div><div style=3D"font-size:1=
2.8px"><font face=3D"monospace, monospace">sdo 179228</font></div><div styl=
e=3D"font-size:12.8px"><font face=3D"monospace, monospace">sdp 181386</font=
></div><div style=3D"font-size:12.8px"><font face=3D"monospace, monospace">=
sdq 180374</font></div><div style=3D"font-size:12.8px"><font face=3D"monosp=
ace, monospace">sdr 232184</font></div><div style=3D"font-size:12.8px"><fon=
t face=3D"monospace, monospace">sds 181994</font></div><div style=3D"font-s=
ize:12.8px"><font face=3D"monospace, monospace">sdt 234098</font></div><div=
 style=3D"font-size:12.8px"><font face=3D"monospace, monospace">sdu 183868<=
/font></div><div style=3D"font-size:12.8px"><font face=3D"monospace, monosp=
ace">sdv 183976</font></div><div style=3D"font-size:12.8px"><font face=3D"m=
onospace, monospace">sdw 182562</font></div><div style=3D"font-size:12.8px"=
><font face=3D"monospace, monospace">sdx 201236</font></div><div style=3D"f=
ont-size:12.8px"><font face=3D"monospace, monospace">sdy 192874</font></div=
><div style=3D"font-size:12.8px"><font face=3D"monospace, monospace">sdz 18=
1240</font></div><div style=3D"font-size:12.8px"><font face=3D"monospace, m=
onospace">sdaa 184892</font></div><div style=3D"font-size:12.8px"><font fac=
e=3D"monospace, monospace">sdab 191350</font></div><div style=3D"font-size:=
12.8px"><font face=3D"monospace, monospace">sdac 179804</font></div><span c=
lass=3D"im" style=3D"font-size:12.8px"><div><font face=3D"monospace, monosp=
ace"><br></font></div><div><font face=3D"monospace, monospace"><br></font><=
/div><div><font face=3D"monospace, monospace"><br></font></div><div><font f=
ace=3D"monospace, monospace">Device: =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0tps =C2=A0 =C2=A0kB_read/s =C2=A0 =C2=A0kB_wrtn/s =C2=A0 =C2=A0kB_read =
=C2=A0 =C2=A0kB_wrtn</font></div></span><div style=3D"font-size:12.8px"><fo=
nt face=3D"monospace, monospace">sda =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A019.00 =C2=A0 =C2=A0 =C2=A02056.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 8.0=
0 =C2=A0 =C2=A0 =C2=A0 4112 =C2=A0 =C2=A0 =C2=A0 =C2=A0 16</font></div><spa=
n class=3D"im" style=3D"font-size:12.8px"><div><font face=3D"monospace, mon=
ospace">sdb =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00</font></div><div>=
<font face=3D"monospace, monospace">sdc =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A00</font></div><div><font face=3D"monospace, monospace">sdd =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00</font></div><div><font face=3D"monospac=
e, monospace">sde =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00</font></div><=
div><font face=3D"monospace, monospace">sdf =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A00</font></div><div><font face=3D"monospace, monospace">sdg =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00</font></div><div><font face=3D"mon=
ospace, monospace">sdh =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.0=
0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00</font></di=
v><div><font face=3D"monospace, monospace">sdi =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A00</font></div><div><font face=3D"monospace, monospace">sdj =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00</font></div><div><font face=3D"=
monospace, monospace">sdk =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00</font>=
</div><div><font face=3D"monospace, monospace">sdl =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A00</font></div><div><font face=3D"monospace, monospace">=
sdm =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00</font></div><div><font face=
=3D"monospace, monospace">sdn =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00</fo=
nt></div></span><div style=3D"font-size:12.8px"><font face=3D"monospace, mo=
nospace">sdo =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00</font></div><div =
style=3D"font-size:12.8px"><font face=3D"monospace, monospace">sdp =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00</font></div><div style=3D"font-size:12.=
8px"><font face=3D"monospace, monospace">sdq =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A00</font></div><div style=3D"font-size:12.8px"><font face=3D"m=
onospace, monospace">sdr =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 197.00 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0100864.00 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 201728</font></div><div style=3D"font-size=
:12.8px"><font face=3D"monospace, monospace">sds =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A00</font></div><div style=3D"font-size:12.8px"><font fac=
e=3D"monospace, monospace">sdt =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.=
00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00<=
/font></div><div style=3D"font-size:12.8px"><font face=3D"monospace, monosp=
ace">sdu =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00</font></div><div sty=
le=3D"font-size:12.8px"><font face=3D"monospace, monospace">sdv =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.0=
0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00</font></div><div style=3D"font-size:12.8px=
"><font face=3D"monospace, monospace">sdw =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A00</font></div><div style=3D"font-size:12.8px"><font face=3D"mo=
nospace, monospace">sdx =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.=
00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00</font></d=
iv><div style=3D"font-size:12.8px"><font face=3D"monospace, monospace">sdy =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00</font></div><div style=3D"font-=
size:12.8px"><font face=3D"monospace, monospace">sdz =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A00</font></div><div style=3D"font-size:12.8px"><font fa=
ce=3D"monospace, monospace">sdaa =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A00.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.0=
0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00</=
font></div><div style=3D"font-size:12.8px"><font face=3D"monospace, monospa=
ce">sdab =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00.00 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00</font></div><div style=
=3D"font-size:12.8px"><font face=3D"monospace, monospace">sdac =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0.00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00</font></div><div style=3D"font-size:12.8px=
"><font face=3D"monospace, monospace">cln4:/home/hdd_test# date; ./disp_tot=
al_iops_512k.sh=C2=A0</font></div><div style=3D"font-size:12.8px"><font fac=
e=3D"monospace, monospace">Thu Nov 19 <span style=3D"background-color:rgb(2=
55,255,0)">10:27:31</span> PST 2015</font></div><div style=3D"font-size:12.=
8px"><font face=3D"monospace, monospace">sdb 207564</font></div><div style=
=3D"font-size:12.8px"><font face=3D"monospace, monospace">sdc 183418</font>=
</div><div style=3D"font-size:12.8px"><font face=3D"monospace, monospace">s=
dd 232922</font></div><div style=3D"font-size:12.8px"><font face=3D"monospa=
ce, monospace">sde 182338</font></div><div style=3D"font-size:12.8px"><font=
 face=3D"monospace, monospace">sdf 182166</font></div><div style=3D"font-si=
ze:12.8px"><font face=3D"monospace, monospace">sdg 181010</font></div><div =
style=3D"font-size:12.8px"><font face=3D"monospace, monospace">sdh 201704</=
font></div><div style=3D"font-size:12.8px"><font face=3D"monospace, monospa=
ce">sdi 187256</font></div><div style=3D"font-size:12.8px"><font face=3D"mo=
nospace, monospace">sdj 200326</font></div><div style=3D"font-size:12.8px">=
<font face=3D"monospace, monospace">sdk 184790</font></div><div style=3D"fo=
nt-size:12.8px"><font face=3D"monospace, monospace">sdl 228202</font></div>=
<div style=3D"font-size:12.8px"><font face=3D"monospace, monospace">sdm 181=
900</font></div><div style=3D"font-size:12.8px"><font face=3D"monospace, mo=
nospace">sdn 179394</font></div><div style=3D"font-size:12.8px"><font face=
=3D"monospace, monospace">sdo 179228</font></div><div style=3D"font-size:12=
.8px"><font face=3D"monospace, monospace">sdp 181386</font></div><div style=
=3D"font-size:12.8px"><font face=3D"monospace, monospace">sdq 180374</font>=
</div><div style=3D"font-size:12.8px"><font face=3D"monospace, monospace">s=
dr=C2=A0<span style=3D"background-color:rgb(255,255,0)">238277</span></font=
></div><div style=3D"font-size:12.8px"><font face=3D"monospace, monospace">=
sds 181994</font></div><div style=3D"font-size:12.8px"><font face=3D"monosp=
ace, monospace">sdt 238404</font></div><div style=3D"font-size:12.8px"><fon=
t face=3D"monospace, monospace">sdu 183868</font></div><div style=3D"font-s=
ize:12.8px"><font face=3D"monospace, monospace">sdv 183976</font></div><div=
 style=3D"font-size:12.8px"><font face=3D"monospace, monospace">sdw 182562<=
/font></div><div style=3D"font-size:12.8px"><font face=3D"monospace, monosp=
ace">sdx 201236</font></div><div style=3D"font-size:12.8px"><font face=3D"m=
onospace, monospace">sdy 192874</font></div><div style=3D"font-size:12.8px"=
><font face=3D"monospace, monospace">sdz 181240</font></div><div style=3D"f=
ont-size:12.8px"><font face=3D"monospace, monospace">sdaa 184892</font></di=
v><div style=3D"font-size:12.8px"><font face=3D"monospace, monospace">sdab =
191350</font></div><div style=3D"font-size:12.8px"><font face=3D"monospace,=
 monospace">sdac 179804</font></div><div style=3D"font-size:12.8px"><font f=
ace=3D"monospace, monospace"><br></font></div><div style=3D"font-size:12.8p=
x"><font face=3D"monospace, monospace"><br></font></div><div style=3D"font-=
size:12.8px"><font face=3D"monospace, monospace">All done at more than 5 mi=
nutes past the 15 minute mark.</font></div><div style=3D"font-size:12.8px">=
<font face=3D"monospace, monospace"><br></font></div><div style=3D"font-siz=
e:12.8px"><font face=3D"monospace, monospace">cln4:/home/hdd_test# date; ./=
disp_total_iops_512k.sh=C2=A0</font></div><div style=3D"font-size:12.8px"><=
font face=3D"monospace, monospace">Thu Nov 19 10:27:51 PST 2015</font></div=
><div style=3D"font-size:12.8px"><font face=3D"monospace, monospace">sdb 20=
7564</font></div><div style=3D"font-size:12.8px"><font face=3D"monospace, m=
onospace">sdc 183418</font></div><div style=3D"font-size:12.8px"><font face=
=3D"monospace, monospace">sdd 232922</font></div><div style=3D"font-size:12=
.8px"><font face=3D"monospace, monospace">sde 182338</font></div><div style=
=3D"font-size:12.8px"><font face=3D"monospace, monospace">sdf 182166</font>=
</div><div style=3D"font-size:12.8px"><font face=3D"monospace, monospace">s=
dg 181010</font></div><div style=3D"font-size:12.8px"><font face=3D"monospa=
ce, monospace">sdh 201704</font></div><div style=3D"font-size:12.8px"><font=
 face=3D"monospace, monospace">sdi 187256</font></div><div style=3D"font-si=
ze:12.8px"><font face=3D"monospace, monospace">sdj 200326</font></div><div =
style=3D"font-size:12.8px"><font face=3D"monospace, monospace">sdk 184790</=
font></div><div style=3D"font-size:12.8px"><font face=3D"monospace, monospa=
ce">sdl 228202</font></div><div style=3D"font-size:12.8px"><font face=3D"mo=
nospace, monospace">sdm 181900</font></div><div style=3D"font-size:12.8px">=
<font face=3D"monospace, monospace">sdn 179394</font></div><div style=3D"fo=
nt-size:12.8px"><font face=3D"monospace, monospace">sdo 179228</font></div>=
<div style=3D"font-size:12.8px"><font face=3D"monospace, monospace">sdp 181=
386</font></div><div style=3D"font-size:12.8px"><font face=3D"monospace, mo=
nospace">sdq 180374</font></div><div style=3D"font-size:12.8px"><font face=
=3D"monospace, monospace">sdr 238426</font></div><div style=3D"font-size:12=
.8px"><font face=3D"monospace, monospace">sds 181994</font></div><div style=
=3D"font-size:12.8px"><font face=3D"monospace, monospace">sdt 238404</font>=
</div><div style=3D"font-size:12.8px"><font face=3D"monospace, monospace">s=
du 183868</font></div><div style=3D"font-size:12.8px"><font face=3D"monospa=
ce, monospace">sdv 183976</font></div><div style=3D"font-size:12.8px"><font=
 face=3D"monospace, monospace">sdw 182562</font></div><div style=3D"font-si=
ze:12.8px"><font face=3D"monospace, monospace">sdx 201236</font></div><div =
style=3D"font-size:12.8px"><font face=3D"monospace, monospace">sdy 192874</=
font></div><div style=3D"font-size:12.8px"><font face=3D"monospace, monospa=
ce">sdz 181240</font></div><div style=3D"font-size:12.8px"><font face=3D"mo=
nospace, monospace">sdaa 184892</font></div><div style=3D"font-size:12.8px"=
><font face=3D"monospace, monospace">sdab 191350</font></div><div style=3D"=
font-size:12.8px"><font face=3D"monospace, monospace">sdac 179804</font></d=
iv></div></div></div><div class=3D"gmail_extra"><br><div class=3D"gmail_quo=
te">On Fri, Nov 20, 2015 at 10:28 AM, Allen Schade <span dir=3D"ltr">&lt;<a=
 href=3D"mailto:aschade@google.com" target=3D"_blank">aschade@google.com</a=
>&gt;</span> wrote:<br><blockquote class=3D"gmail_quote" style=3D"margin:0 =
0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex">Jens,<br>
We tried with the latest version and gathered some detailed info.<br>
<br>
Hey Caio,<br>
Can you paste your experiment information as a reply here. Also switch<br>
your email to plain text mode or the <a href=3D"http://vger.kernel.org" rel=
=3D"noreferrer" target=3D"_blank">vger.kernel.org</a> email address<br>
will reject your email as spam.<br>
<br>
On Fri, Nov 13, 2015 at 2:06 PM, Jens Axboe &lt;<a href=3D"mailto:axboe@ker=
nel.dk">axboe@kernel.dk</a>&gt; wrote:<br>
&gt; On 11/13/2015 03:04 PM, Allen Schade wrote:<br>
&gt;&gt;<br>
&gt;&gt; I&#39;m actually launching a completely separate instance of fio f=
or each<br>
&gt;&gt; disk. I want to say its because when I ran them under the same fio=
<br>
&gt;&gt; process I had issues with the json files merging the data in an<br=
>
&gt;&gt; unexpected way.<br>
&gt;<br>
&gt;<br>
&gt; OK - in any case, that should be fine.<br>
&gt;<br>
&gt;&gt; Version is 2.2.6<br>
&gt;<br>
&gt;<br>
&gt; Could you try current -git? I vaguely remember some clock issue that c=
ould<br>
&gt; have caused this.<br>
<span class=3D"HOEnZb"><font color=3D"#888888">&gt;<br>
&gt; --<br>
&gt; Jens Axboe<br>
&gt;<br>
</font></span></blockquote></div><br></div>

--001a1140f36afd55af0524fe0258--

