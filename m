Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-it1-f174.google.com ([209.85.166.174]:38924 "EHLO
        mail-it1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726886AbeJLBUE (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 11 Oct 2018 21:20:04 -0400
Received: by mail-it1-f174.google.com with SMTP id w200-v6so14482028itc.4
        for <fio@vger.kernel.org>; Thu, 11 Oct 2018 10:51:47 -0700 (PDT)
MIME-Version: 1.0
From: smitha sunder <sundersmitha@gmail.com>
Date: Thu, 11 Oct 2018 10:51:36 -0700
Message-ID: <CA+zhgFRC+POb+WouXuMRmVq9+RU9iA7aeoPowZGpHskijdmWmg@mail.gmail.com>
Subject: JSON versus terse : latency_us : "2"
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio <fio@vger.kernel.org>

Hi,

I have a question with respect to the JSON output versus terse output
(version 4).
There appears to be a different in the latency_us for "2" between the
two outputs for latency_us.

In JSON its 11.5% for 2 us, but in terse output its 56.70%, the rest
of the %s seem to be matching i.e 2,4,10,20,20 usecs :

From the JSON output :
      "latency_us" : {
        "2" : 11.500203, <----
        "4" : 40.336987,
        "10" : 2.821762,
        "20" : 0.121803,
        "50" : 0.020300,
        "100" : 0.000000,
        "250" : 0.000000,
        "500" : 0.000000,
        "750" : 0.000000,
        "1000" : 0.000000
      },

Terse output :
lat_2us 56.70% <---
lat_4us 40.34%
lat_10us 2.82%
lat_20us 0.12%
lat_50us 0.02%
lat_100us 0.00%
lat_250us 0.00%
lat_500us 0.00%
lat_750us 0.00%
lat_1000us 0.00%


4;fio-3.11;trim_ul_512_1_p0;0;0;0;0;0;0;0;0;0.000000;0.000000;0;0;0.000000;=
0.000000;1.000000%=3D0;5.000000%=3D0;10.000000%=3D0;20.000000%=3D0;30.00000=
0%=3D0;40.000000%=3D0;50.000000%=3D0;60.000000%=3D0;70.000000%=3D0;80.00000=
0%=3D0;90.000000%=3D0;95.000000%=3D0;99.000000%=3D0;99.500000%=3D0;99.90000=
0%=3D0;99.950000%=3D0;99.990000%=3D0;99.999000%=3D0;99.999900%=3D0;99.99999=
0%=3D0;0;0;0.000000;0.000000;0;0;0.000000%;0.000000;0.000000;2463;123;246;2=
0002;0;0;0.000000;0.000000;0;15;2.770458;0.861419;1.000000%=3D0;5.000000%=
=3D1;10.000000%=3D1;20.000000%=3D2;30.000000%=3D2;40.000000%=3D2;50.000000%=
=3D2;60.000000%=3D2;70.000000%=3D2;80.000000%=3D3;90.000000%=3D3;95.000000%=
=3D4;99.000000%=3D4;99.500000%=3D4;99.900000%=3D14;99.950000%=3D14;99.99000=
0%=3D15;99.999000%=3D15;99.999900%=3D15;99.999990%=3D15;2;432;56.459681;95.=
161235;113;165;100.000000%;123.000000;13.424050;2463;123;246;20002;0;0;0.00=
0000;0.000000;0;32;0.863402;0.819190;1.000000%=3D0;5.000000%=3D0;10.000000%=
=3D0;20.000000%=3D0;30.000000%=3D0;40.000000%=3D0;50.000000%=3D0;60.000000%=
=3D0;70.000000%=3D0;80.000000%=3D0;90.000000%=3D1;95.000000%=3D1;99.000000%=
=3D1;99.500000%=3D1;99.900000%=3D14;99.950000%=3D14;99.990000%=3D32;99.9990=
00%=3D32;99.999900%=3D32;99.999990%=3D32;1008;9329;3994.007577;703.493133;1=
13;165;99.979675%;122.975000;13.411605;0.959952%;2.699865%;5543;0;0;104.9%;=
0.0%;0.0%;0.0%;0.0%;0.0%;0.0%;56.70%;40.34%;2.82%;0.12%;0.02%;0.00%;0.00%;0=
.00%;0.00%;0.00%;0.00%;0.00%;0.00%;0.00%;0.00%;0.00%;0.00%;0.00%;0.00%;0.00=
%;0.00%;0.00%;sdb;691;5170;0;458;124;20104;20232;95.95%

Thanks
smitha

