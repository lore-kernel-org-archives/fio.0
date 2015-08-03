Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-la0-f51.google.com ([209.85.215.51]:34259 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932358AbbHCVMO (ORCPT <rfc822;fio@vger.kernel.org>);
	Mon, 3 Aug 2015 17:12:14 -0400
Received: by labow3 with SMTP id ow3so25518957lab.1
        for <fio@vger.kernel.org>; Mon, 03 Aug 2015 14:12:12 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 3 Aug 2015 22:12:12 +0100
Message-ID: <CALjAwxh7sx3OHw9Gb=gBwet+YqpJNNDzZusNZK7X7bGK0Z06pQ@mail.gmail.com>
Subject: server mode and verify_dump
From: Sitsofe Wheeler <sitsofe@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio <fio@vger.kernel.org>

Hi,

I've noticed that when running fio in server mode it's not possible to
get a dump of using verify_dump when a verify mismatch occurs. Is it
possible to add a mode where the server process saves the mismatch
files to its current working directory for inspection later?

-- 
Sitsofe | http://sucs.org/~sits/
