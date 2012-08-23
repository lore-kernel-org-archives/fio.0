Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:58804 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755702Ab2HWAce (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 22 Aug 2012 20:32:34 -0400
Received: by ialo24 with SMTP id o24so317832ial.19
        for <fio@vger.kernel.org>; Wed, 22 Aug 2012 17:32:34 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 22 Aug 2012 19:32:33 -0500
Message-ID: <CA+bjhhSHkDH-bAOo6_zRw4gRPqcc=R5JKq4gh61Nt+reeX8CvA@mail.gmail.com>
Subject: fio client/server with different job files
From: Frank Leers <fleers@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hello,

Is it possible to lanch fio against multiple servers, each having a
unique job file?

example

(assume fio --server started already on these two nodes)
# fio --client=node2 jobfile_for_node2 --client=node3 jobfile_for_node3.cfg

Alternately, is there a directive that can be placed into a common job
file which would cause a specific server only to run jobs with that
directive?

example


# fio --client=node2 --client=node3 jobfile.cfg


jobfile contains:

[for_node2_only]
filename=/dev/shareddiskA
readwrite=read
runtime=60
ioengine=libaio
direct=1
iodepth=32
fsync_on_close=0
time_based
ioscheduler=noop
blocksize=4M
client=node2


[for_node3_only]
filename=/dev/shareddiskB
readwrite=read
runtime=60
ioengine=libaio
direct=1
iodepth=32
fsync_on_close=0
time_based
ioscheduler=noop
blocksize=4M
client=node3


Thanks for the very nice utility.

-frank
