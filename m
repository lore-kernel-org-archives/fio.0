Return-Path: <fio-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231157AbhBJNZL (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 10 Feb 2021 08:25:11 -0500
Received: from mail-il1-x130.google.com (mail-il1-x130.google.com [IPv6:2607:f8b0:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DFB9C061574
        for <fio@vger.kernel.org>; Wed, 10 Feb 2021 05:24:15 -0800 (PST)
Received: by mail-il1-x130.google.com with SMTP id y5so1792504ilg.4
        for <fio@vger.kernel.org>; Wed, 10 Feb 2021 05:24:15 -0800 (PST)
MIME-Version: 1.0
From: Robert Balogh <ethrbh@gmail.com>
Date: Wed, 10 Feb 2021 14:24:03 +0100
Message-ID: <CAA4OwwVJuUWCkA_ZRJC+izsqx-4Mv2BG+vvR=JCv2A7kOr343Q@mail.gmail.com>
Subject: how to put FIO stat into file and check that periodically while FIO
 is running
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

hello FIO experts,

I have installed fio-3.25 on my Ubuntu-20.04. The FIO itself is
working well (can start and finally get stat when terminate FIO).

ethrbh@ethrbh-VmWare:~/BAT-image_Tools/Github/fio((fio-3.25))>
ethrbh@ethrbh-VmWare:~/BAT-image_Tools/Github/fio((fio-3.25))> sudo
/home/ethrbh/BAT-image_Tools-installed/bin/fio  --output=3D/tmp/f2.log
--minimal examples/latency-profile.fio
^Cethrbh@ethrbh-VmWare:~/BAT-image_Tools/Github/fio((fio-3.25))> ]
ethrbh@ethrbh-VmWare:~/BAT-image_Tools/Github/fio((fio-3.25))>
ethrbh@ethrbh-VmWare:~/BAT-image_Tools/Github/fio((fio-3.25))>
ethrbh@ethrbh-VmWare:~/BAT-image_Tools/Github/fio((fio-3.25))> cat /tmp/f2.=
log

fio: terminating on signal 2
3;fio-3.25;device;0;0;135644;14610;3652;9284;0;0;0.000000;0.000000;36;10323=
;272.037450;147.520064;1.000000%=3D85;5.000000%=3D146;10.000000%=3D195;20.0=
00000%=3D216;30.000000%=3D228;40.000000%=3D240;50.000000%=3D252;60.000000%=
=3D272;70.000000%=3D284;80.000000%=3D301;90.000000%=3D350;95.000000%=3D407;=
99.000000%=3D749;99.500000%=3D1105;99.900000%=3D1597;99.950000%=3D1843;99.9=
90000%=3D5079;0%=3D0;0%=3D0;0%=3D0;37;10323;272.212542;147.633037;10522;167=
76;100.000000%;14627.166667;1517.869104;0;0;0;0;0;0;0.000000;0.000000;0;0;0=
.000000;0.000000;1.000000%=3D0;5.000000%=3D0;10.000000%=3D0;20.000000%=3D0;=
30.000000%=3D0;40.000000%=3D0;50.000000%=3D0;60.000000%=3D0;70.000000%=3D0;=
80.000000%=3D0;90.000000%=3D0;95.000000%=3D0;99.000000%=3D0;99.500000%=3D0;=
99.900000%=3D0;99.950000%=3D0;99.990000%=3D0;0%=3D0;0%=3D0;0%=3D0;0;0;0.000=
000;0.000000;0;0;0.000000%;0.000000;0.000000;1.228051%;4.933750%;33922;0;13=
;100.0%;0.0%;0.0%;0.0%;0.0%;0.0%;0.0%;0.00%;0.00%;0.00%;0.00%;0.17%;1.29%;4=
6.10%;50.02%;1.43%;0.40%;0.57%;0.02%;0.01%;0.01%;0.00%;0.00%;0.00%;0.00%;0.=
00%;0.00%;0.00%;0.00%;sda;33357;2;0;9;8604;1;12;99.00%
ethrbh@ethrbh-VmWare:~/BAT-image_Tools/Github/fio((fio-3.25))>


What I would like to do is now, to start FIO, keep running it, and
"instruct/ask" FIO for putting the measurement statistic at every X
sec into the given stat file. Is it possible to do?

thanks for your help,
/Robi

