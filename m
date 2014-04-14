Return-Path: <fio-owner@vger.kernel.org>
Received: from hermes.informatik.uni-rostock.de ([139.30.5.210]:47049 "EHLO
	hermes.informatik.uni-rostock.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754464AbaDNMta (ORCPT
	<rfc822;fio@vger.kernel.org>); Mon, 14 Apr 2014 08:49:30 -0400
Received: from ekas.informatik.uni-rostock.de (ekas.informatik.uni-rostock.de [139.30.1.211])
	by hermes.informatik.uni-rostock.de (8.14.3+Sun/8.12.4/poprelay-1.0) with ESMTP id s3ECeppq025879
	for <fio@vger.kernel.org>; Mon, 14 Apr 2014 14:40:52 +0200 (CEST)
Received: from [139.30.96.67] (nj-desktop.informatik.uni-rostock.de [139.30.96.67])
	by ekas.informatik.uni-rostock.de (8.14.4+Sun/8.9.1/fin2.2) with ESMTP id s3ECeplc011196
	for <fio@vger.kernel.org>; Mon, 14 Apr 2014 14:40:51 +0200 (MEST)
Message-ID: <534BD74E.1080205@informatik.uni-rostock.de>
Date: Mon, 14 Apr 2014 14:40:46 +0200
From: Nikolaus Jeremic <jeremic@informatik.uni-rostock.de>
MIME-Version: 1.0
Subject: Writing an amount of data less than capacity at random to offsets
 from whole address range
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hello,

how can I nudge fio to write a certain amount of data (less than 
capacity of block device) to randomly generated offsets covering the 
whole address space of a block device (e.g. MD RAID device)?

Using the size parameter yields offsets from 0 to size (thus, not 
covering the whole address range). Using a time based job leads to the 
desired result, but I would like two write a defined amount of data. I 
have already tried this with fio 2.0.14, 2.1.6.1, 2.1.17, and 2.1.18 
without success. I am using Gentoo Linux with kernel 3.13.6 and libaio 
0.3.109. The job description looks as follows:

######################
[global]
name=rw-04k
ioengine=libaio
iodepth=512
direct=1
continue_on_error=1
rw=randwrite
norandommap
filename=/dev/md9
bs=4k
ba=4k
numjobs=1
stonewall
size=1G

[rand-writes-04k]
#####################

Thanks,
Nikolaus


-- 
Dipl.-Inf. Nikolaus Jeremic          nikolaus.jeremic@uni-rostock.de
Universitaet Rostock                 Tel:  (+49) 381 / 498 - 7635
Albert-Einstein-Str. 22	             Fax:  (+49) 381 / 498 - 7482
18059 Rostock, Germany               wwwava.informatik.uni-rostock.de
