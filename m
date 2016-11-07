Return-Path: <fio-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:51086 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752071AbcKGLV0 (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 7 Nov 2016 06:21:26 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 5B517AB03
        for <fio@vger.kernel.org>; Mon,  7 Nov 2016 11:21:25 +0000 (UTC)
From: Denis Polom <dpolom@suse.de>
Subject: fio bug report
Message-ID: <ee28d36c-8fd0-66cd-10c2-817a75f7d9c0@suse.de>
Date: Mon, 7 Nov 2016 12:21:24 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hi

on version fio-2.13-1.25.x86_64 I found following bug:

when fio is executed with options to write to files (etc : 
--write_iops_log, --write_bw_log, --write_lat_log) it creates files with 
wrong value for one of the coordinates. So creating the graphs by 
gnuplot is not possible.

file context example:

341692, 0, 1, 1048576
342510, 0, 1, 1048576
343728, 0, 1, 1048576
344551, 0, 1, 1048576

In old fio version fio-2.8-1.34.x86_64 was everything fine:

339208, 86, 1, 1048576
340561, 26, 1, 1048576
341692, 54, 1, 1048576
342510, 72, 1, 1048576

Thank you

Denis


