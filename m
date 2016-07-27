Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:35050 "EHLO
	mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752540AbcG0GV7 convert rfc822-to-8bit (ORCPT
	<rfc822;fio@vger.kernel.org>); Wed, 27 Jul 2016 02:21:59 -0400
Received: by mail-pf0-f196.google.com with SMTP id h186so1236652pfg.2
        for <fio@vger.kernel.org>; Tue, 26 Jul 2016 23:21:59 -0700 (PDT)
Received: from [10.234.19.188] ([166.170.43.24])
        by smtp.gmail.com with ESMTPSA id wp4sm5814625pab.15.2016.07.26.23.21.56
        for <fio@vger.kernel.org>
        (version=TLS1 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Tue, 26 Jul 2016 23:21:57 -0700 (PDT)
From: seth roth <sethrroth@gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Subject: more information around io: client: unable to find matching tag - fio: client.c:1241: handle_eta: Assertion `client->eta_in_flight == eta' failed
Message-Id: <652DFA88-EEE6-4E46-83FE-1525931F721A@gmail.com>
Date: Tue, 26 Jul 2016 23:21:53 -0700
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

version -

[root@tme-sj-s16 4krd]# fio --version
fio-2.12

OS

SB Version:    :core-4.1-amd64:core-4.1-noarch

at /etc/redhat-release
Red Hat Enterprise Linux Server release 7.2 (Maipo)

command on launcher node:
/usr/local/bin/fio --client=tme-sj-s27.lab 4kread_s27.job --client=tme-sj-s28.lab 4kread_s28.job --client=tme-sj-s29.lab 4kread_s29.job --client=tme-sj-s30.lab 4kread_s30.job --output=./4krd_qd6.txt

—output=4krd_qd6.txt

cat 4krd_qd6.txt
hostname=tme-sj-s30, be=0, 64-bit, os=Linux, arch=x86-64, fio=fio-2.12, flags=1
hostname=tme-sj-s29, be=0, 64-bit, os=Linux, arch=x86-64, fio=fio-2.12, flags=1
hostname=tme-sj-s28, be=0, 64-bit, os=Linux, arch=x86-64, fio=fio-2.12, flags=1
hostname=tme-sj-s27, be=0, 64-bit, os=Linux, arch=x86-64, fio=fio-2.12, flags=1
<tme-sj-s30> IF_4krd_30_qd6: (g=0): rw=randread, <tme-sj-s29> IF_4krd_29_qd6: (g=0): rw=randread, <tme-sj-s28> IF_4krd_28_qd6: (g=0): rw=randread, <tme-sj-s27> IF_4krd_27_qd6: (g=0): rw=randread, bs=4K-4K/4K-4K/4K-4K, bs=4K-4K/4K-4K/4K-4K, bs=4K-4K/4K-4K/4K-4K, bs=4K-4K/4K-4K/4K-4K, ioengine=rbd, iodepth=6
ioengine=rbd, iodepth=6
ioengine=rbd, iodepth=6
ioengine=rbd, iodepth=6
<tme-sj-s30> ...
<tme-sj-s29> ...
<tme-sj-s28> ...
<tme-sj-s27> ...
<tme-sj-s29> Starting 10 processes
<tme-sj-s29> rbd engine: RBD version: 0.1.9
<tme-sj-s28> Starting 10 processes
<tme-sj-s28> rbd engine: RBD version: 0.1.9
<tme-sj-s27> Starting 10 processes
<tme-sj-s27> rbd engine: RBD version: 0.1.9
<tme-sj-s30> Starting 10 processes
<tme-sj-s30> rbd engine: RBD version: 0.1.9
<tme-sj-s29> rbd engine: RBD version: 0.1.9
<tme-sj-s28> rbd engine: RBD version: 0.1.9
<tme-sj-s27> rbd engine: RBD version: 0.1.9
<tme-sj-s30> rbd engine: RBD version: 0.1.9
<tme-sj-s29> rbd engine: RBD version: 0.1.9
<tme-sj-s28> rbd engine: RBD version: 0.1.9
<tme-sj-s27> rbd engine: RBD version: 0.1.9
<tme-sj-s30> rbd engine: RBD version: 0.1.9
<tme-sj-s29> rbd engine: RBD version: 0.1.9
<tme-sj-s28> rbd engine: RBD version: 0.1.9
<tme-sj-s27> rbd engine: RBD version: 0.1.9
<tme-sj-s30> rbd engine: RBD version: 0.1.9
<tme-sj-s29> rbd engine: RBD version: 0.1.9
<tme-sj-s28> rbd engine: RBD version: 0.1.9
<tme-sj-s27> rbd engine: RBD version: 0.1.9
<tme-sj-s30> rbd engine: RBD version: 0.1.9
<tme-sj-s29> rbd engine: RBD version: 0.1.9
<tme-sj-s28> rbd engine: RBD version: 0.1.9
<tme-sj-s27> rbd engine: RBD version: 0.1.9
<tme-sj-s30> rbd engine: RBD version: 0.1.9
<tme-sj-s29> rbd engine: RBD version: 0.1.9
<tme-sj-s28> rbd engine: RBD version: 0.1.9
<tme-sj-s27> rbd engine: RBD version: 0.1.9
<tme-sj-s30> rbd engine: RBD version: 0.1.9
<tme-sj-s29> rbd engine: RBD version: 0.1.9
<tme-sj-s28> rbd engine: RBD version: 0.1.9
<tme-sj-s27> rbd engine: RBD version: 0.1.9
<tme-sj-s29> rbd engine: RBD version: 0.1.9
<tme-sj-s30> rbd engine: RBD version: 0.1.9
<tme-sj-s28> rbd engine: RBD version: 0.1.9
<tme-sj-s27> rbd engine: RBD version: 0.1.9
<tme-sj-s29> rbd engine: RBD version: 0.1.9
<tme-sj-s30> rbd engine: RBD version: 0.1.9
<tme-sj-s28> rbd engine: RBD version: 0.1.9
<tme-sj-s27> rbd engine: RBD version: 0.1.9
<tme-sj-s30> rbd engine: RBD version: 0.1.9
client <tme-sj-s30.lab>: timeout on SEND_ETA
client <tme-sj-s29.lab>: timeout on SEND_ETA
client <tme-sj-s28.lab>: timeout on SEND_ETA
client <tme-sj-s27.lab>: timeout on SEND_ETA
client <tme-sj-s30.lab>: timeout on SEND_ETA
client <tme-sj-s29.lab>: timeout on SEND_ETA
client <tme-sj-s28.lab>: timeout on SEND_ETA
client <tme-sj-s27.lab>: timeout on SEND_ETA
client <tme-sj-s30.lab>: timeout on SEND_ETA
client <tme-sj-s29.lab>: timeout on SEND_ETA
client <tme-sj-s28.lab>: timeout on SEND_ETA
client <tme-sj-s27.lab>: timeout on SEND_ETA
fio: client: unable to find matching tag (13cca90)