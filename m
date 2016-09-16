Return-Path: <fio-owner@vger.kernel.org>
Received: from 6-212-255-158.static.edis.at ([158.255.212.6]:43858 "EHLO
        graz1.feltside.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1752057AbcIPJIq (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 16 Sep 2016 05:08:46 -0400
Received: from graz1.feltside.com (localhost.localdomain [127.0.0.1])
        by graz1.feltside.com (Postfix) with ESMTP id 98CE848273
        for <fio@vger.kernel.org>; Fri, 16 Sep 2016 08:41:28 +0000 (GMT)
Subject: disk utilization in terse output
From: =?utf-8?Q?Bernhard_Furtmueller?= 
        <bernhard.furtmueller@feltside.com>
Date: Fri, 16 Sep 2016 08:41:28 +0000
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Message-Id: <zarafa.57dbb038.6c23.6a4005270eee99fc@graz1.feltside.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: =?utf-8?Q?fio=40vger=2Ekernel=2Eorg?= <fio@vger.kernel.org>

Hi,

If browsing the minimum output of the complete fio run I noticed that the
disk utilization is summarized over all sections (at least it seems so),
here for dm and one subdevice:

One fio run (see the groupid increasing)
3	fio-2.13	write	0
3	fio-2.13	random-write	1
3	fio-2.13	random-read	2
3	fio-2.13	read	3
3	fio-2.13	randrw	4
3	fio-2.13	rw	5

Here one dm-device:
dm-8	550045	707302	0	0	3513180	4029418	7546643	94,96%
dm-8	550045	707302	0	0	3513180	4029418	7546643	94,96%
dm-8	550045	707302	0	0	3513180	4029418	7546643	94,96%
dm-8	550045	707302	0	0	3513180	4029418	7546643	94,96%
dm-8	550045	707302	0	0	3513180	4029418	7546643	94,96%
dm-8	550045	707302	0	0	3513180	4029418	7546643	94,96%

and the phsyical below that one:
sdh	287045	456931	262374	252536	1254009	1718403	2973177	94,95%
sdh	287045	456931	262374	252536	1254009	1718403	2973177	94,95%
sdh	287045	456931	262374	252536	1254009	1718403	2973177	94,95%
sdh	287045	456931	262374	252536	1254009	1718403	2973177	94,95%
sdh	287045	456931	262374	252536	1254009	1718403	2973177	94,95%
sdh	287045	456931	262374	252536	1254009	1718403	2973177	94,95%


For me this output seems somehow "wrong" or at least unexpected,
I would rather expect to see something like this (if you run the sections individually):
(see groupid always 0)
3	fio-2.13	write	0
3	fio-2.13	random-write	0
3	fio-2.13	random-read	0
3	fio-2.13	read	0
3	fio-2.13	randrw	0
3	fio-2.13	rw	0

dm-8	0	241093	0	0	0	678358	678619	98,58%
dm-8	0	180308	0	0	0	730751	730825	90,58%
dm-8	62571	2946	0	0	342919	28389	371404	98,49%
dm-8	266462	0	0	0	1026655	0	1028046	98,28%
dm-8	44066	74766	0	0	248412	314647	563386	87,10%
dm-8	200013	205349	0	0	650125	725574	1377033	98,46%

sdh	0	198694	0	46847	0	468245	468165	98,36%
sdh	0	158117	0	24270	0	409853	409791	90,50%
sdh	63450	54	0	2892	346109	380	346458	97,65%
sdh	194258	0	74244	0	476486	0	477030	98,01%
sdh	44839	66028	0	9681	253069	192361	445370	86,70%
sdh	111956	111182	90697	96896	328083	331425	659447	98,28%


Or did I miss a setting which could a "correct" per section disk stats?


thanks,
bernhard
