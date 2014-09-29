Return-Path: <fio-owner@vger.kernel.org>
Received: from blu004-omc1s38.hotmail.com ([65.55.116.49]:58040 "EHLO
	BLU004-OMC1S38.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750819AbaI2D2W (ORCPT
	<rfc822;fio@vger.kernel.org>); Sun, 28 Sep 2014 23:28:22 -0400
Message-ID: <BLU402-EAS71C90924EA427F167AAF17E0BA0@phx.gbl>
From: Jon Tango <cheerios123@outlook.com>
Subject: Limit LBA Range
Date: Sun, 28 Sep 2014 22:28:19 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Language: en-us
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

I am using windows server 2012R2 and am attempting to limit the LBA range of
the test. It doesn't seem to be working, I am using this, is it correct?

[global]
name=4ktest
filename=\\.\physicaldrive1
direct=1
numjobs=8
norandommap
ba=4k
time_based
size=745g
log_avg_msec=100000
group_reporting=1

#########################################################

[4K Precon]
stonewall
runtime=15000
iodepth=32
bs=4k
rw=randwrite

