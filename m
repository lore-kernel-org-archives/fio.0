Return-Path: <fio-owner@vger.kernel.org>
Received: from smtp13.cnnic.cn ([218.241.118.13]:43577 "EHLO cnnic.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753552AbbEUIRE (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 21 May 2015 04:17:04 -0400
Message-ID: <555D9487.3040104@cnnic.cn>
Date: Thu, 21 May 2015 16:17:11 +0800
From: Nan WANG <wangnan@cnnic.cn>
MIME-Version: 1.0
Subject: Urgent problem while using Fio to test random write performance
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: 8bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

hi all~
     I wanted to use fio to test random write performance, the command 
line is as forllowing:

       fio --filename=/dev/sdb1 --direct=1 --iodepth 1 --thread 
--rw=randwrite --ioengine=psync --bs=16k --size=200G --numjobs=10 
--runtime=1000 --group_reporting --name=mytest

     After the execution of fio finished, my disc usage become 100%, is 
there any method to release the content written by Fio?

  Thanks a lot in advance!!

-- 
王楠    技术研发中心
---------------------------------
==专业·责任·服务==
中国互联网络信息中心 CNNIC
网 址: www.cnnic.cn
中国互联网络信息中心.中国
地 址: 北京市海淀区中关村南4街4号
北京349信箱6分箱（100080）
---------------------------------
Nan WANG
Research&Development Center
= =Profession • Responsibility • Service= =
China Internet Network Information Center （CNNIC）
Website: www.cnnic.cn
          中国互联网络信息中心.中国
Add: 4th Zhongguancun Nansijie, Haidian District, Beijing 100190, China
POB: Beijing 349, Branch 6


