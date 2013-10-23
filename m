Return-Path: <fio-owner@vger.kernel.org>
Received: from smtp-o-1.desy.de ([131.169.56.154]:46139 "EHLO smtp-o-1.desy.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751727Ab3JWKxo (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 23 Oct 2013 06:53:44 -0400
Received: from smtp-map-1.desy.de (smtp-map-1.desy.de [131.169.56.66])
	by smtp-o-1.desy.de (DESY-O-1) with ESMTP id C75EB2808DB
	for <fio@vger.kernel.org>; Wed, 23 Oct 2013 12:45:44 +0200 (CEST)
Received: from ZITSWEEP3.win.desy.de (zitsweep3.win.desy.de [131.169.97.97])
	by smtp-map-1.desy.de (DESY_MAP_1) with ESMTP id A4B2B13E85
	for <fio@vger.kernel.org>; Wed, 23 Oct 2013 12:45:44 +0200 (MEST)
Received: from smtp-intra-1.desy.de (lb-40-26.desy.de) by ZITSWEEP3.win.desy.de
 (Clearswift SMTPRS 5.4.1) with ESMTP id <Taef1c22f1183a961611b60@ZITSWEEP3.win.desy.de> for <fio@vger.kernel.org>;
 Wed, 23 Oct 2013 12:45:44 +0200
Received: from zimbratest.desy.de (zimbratest.desy.de [131.169.72.254])
	by smtp-intra-1.desy.de (DESY-INTRA-1) with ESMTP id 651683E902
	for <fio@vger.kernel.org>; Wed, 23 Oct 2013 12:45:44 +0200 (MEST)
Date: Wed, 23 Oct 2013 12:45:44 +0200 (CEST)
From: "Mkrtchyan, Tigran" <tigran.mkrtchyan@desy.de>
Message-ID: <590651218.789538.1382525144344.JavaMail.zimbra@desy.de>
In-Reply-To: <207015768.789438.1382524904131.JavaMail.zimbra@desy.de>
Subject: sequential workload
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org



Hi,

I need to simulate a workload of generating sequence
of files - some thing like creating photos.

where is my config:
[global]
create_on_open=1
unlink=1
filesize=70m
size=7000m

[pilatus-sec-write]
rw=write
openfiles=1
nrfiles=100
stonewall


I will expect that a combination of create_on_open and openfiles
will create one file at the time, nevertheless all files get
created at the same time.

Thanks in advance, 
   Tigran.
