Return-Path: <fio-owner@vger.kernel.org>
Received: from host-181-75-169-83.static.internet-fr.net ([83.169.75.181]:40559
	"EHLO seanodes.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751328AbYKSLXZ (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 19 Nov 2008 06:23:25 -0500
Message-ID: <4923F729.1030200@seanodes.com>
Date: Wed, 19 Nov 2008 12:23:21 +0100
From: Erwan Velu <erwan@seanodes.com>
MIME-Version: 1.0
Subject: Passing argument to both write_bw_log & write_lat_log leads to segfault
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Using fio 1.23:
[root@max13 tmp]# fio myconfigfile
Segmentation fault (core dumped)


Where myconfigfile is the following:
[global]
bsrange=64k-128k,64k-128k
direct=1
ioengine=libaio
iodepth=2
zonesize=256m
zoneskip=2g

[/dev/exa/g1/v1]
rw=read
write_bw_log read-bw
write_lat_log read-lat

[/dev/exa/g1/v1]
stonewall
rw=write
write_bw_log write-bw
write_lat_log write-lat

Note: removing one or the other parameter to write_*_log reports an error like "Bad option write_lat_log read-lat" but letting both of them segfault.

I did this syntaxe as the man page says :
       write_bw_log
              If given, write bandwidth logs of the jobs in this file.

I thought that "this file" meant a parameter.
Cheers,
-- 
Erwan Velu
Pre-Sales Engineer
Seanodes
http://www.seanodes.com
+33 (0)1 41 22 13 83

