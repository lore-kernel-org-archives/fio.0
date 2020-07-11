Return-Path: <fio-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726581AbgGKAce (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 10 Jul 2020 20:32:34 -0400
Received: from mail-ua1-x933.google.com (mail-ua1-x933.google.com [IPv6:2607:f8b0:4864:20::933])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67EB7C08C5DC
        for <fio@vger.kernel.org>; Fri, 10 Jul 2020 17:32:34 -0700 (PDT)
Received: by mail-ua1-x933.google.com with SMTP id b13so2360451uav.3
        for <fio@vger.kernel.org>; Fri, 10 Jul 2020 17:32:34 -0700 (PDT)
MIME-Version: 1.0
From: siha lawrence <sihaj33@gmail.com>
Date: Sat, 11 Jul 2020 08:32:20 +0800
Message-ID: <CAAEM5qLD0+9np-kk+_cRep0JQPDgu6F2p8z7HD397sEKzXwjUw@mail.gmail.com>
Subject: Phy Change count increases during IO in SATA drives
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hi,

Below is the workload we have run and we see PHY changes during I/O
Does fio abort outstanding commands?

Workload:
fio --eta=3Dnever --ioengine=3Dlibaio --size=3D100% --ramp_time=3D10
--runtime=3D40 --time_based=3D1 --verify_backlog=3D1 --verify_dump=3D1
--verify_fatal=3D1 --norandommap --numjobs=3D1 --direct=3D1
--random_generator=3Dtausworthe64 --iodepth=3D8 --rw=3Dwrite --bs=3D1M
--buffer_pattern=3D0xfffefdfcfbfaf9f8f7f6f5f4f3f2f1f0efeeedecebeae9e8e7e6e5=
e4e3e2e1e0dfdedddcdbdad9d8d7d6d5d4d3d2d1d0cfcecdcccbcac9c8c7c6c5c4c3c2c1c0b=
fbebdbcbbbab9b8b7b6b5b4b3b2b1b0afaeadacabaaa9a8a7a6a5a4a3a2a1a09f9e9d9c9b9a=
999897969594939291908f8e8d8c8b8a898887868584838281807f7e7d7c7b7a79787776757=
4737271706f6e6d6c6b6a696867666564636261605f5e5d5c5b5a595857565554535251504f=
4e4d4c4b4a494847464544434241403f3e3d3c3b3a393837363534333231302f2e2d2c2b2a2=
92827262524232221201f1e1d1c1b1a191817161514131211100f0e0d0c0b0a090807060504=
03020100
--minimal --name=3D/dev/sdp --name=3D/dev/sdq --name=3D/dev/sdr
--name=3D/dev/sds --name=3D/dev/sdt --name=3D/dev/sdu --name=3D/dev/sdv
--name=3D/dev/sdw --name=3D/dev/sdx --name=3D/dev/sdy --name=3D/dev/sdz
--name=3D/dev/sdaa --name=3D/dev/sdaf --name=3D/dev/sdag --name=3D/dev/sdah
--name=3D/dev/sdai --name=3D/dev/sdab --name=3D/dev/sdac --name=3D/dev/sdad
--name=3D/dev/sdae --name=3D/dev/sdaj --name=3D/dev/sdak --name=3D/dev/sdal
--name=3D/dev/sdam --name=3D/dev/sdan --name=3D/dev/sdao --name=3D/dev/sdaq
--name=3D/dev/sdap --name=3D/dev/sdf --name=3D/dev/sdg --name=3D/dev/sdh
--name=3D/dev/sdi --name=3D/dev/sdj --name=3D/dev/sdk --name=3D/dev/sdl
--name=3D/dev/sdm --name=3D/dev/sdo --name=3D/dev/sdn --name=3D/dev/sde
--name=3D/dev/sdd --name=3D/dev/sdc --name=3D/dev/sdb

We do not see this behaviour with SAS drives.

Thank you,
Siha

