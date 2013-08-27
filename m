Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-qe0-f42.google.com ([209.85.128.42]:52095 "EHLO
	mail-qe0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751522Ab3H0XPF (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 27 Aug 2013 19:15:05 -0400
Received: by mail-qe0-f42.google.com with SMTP id w7so3031702qeb.15
        for <fio@vger.kernel.org>; Tue, 27 Aug 2013 16:15:04 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 28 Aug 2013 00:15:04 +0100
Message-ID: <CA+BkS8NTwrsKpDnPqzcEBZRtOeK8xtOT0ZqeemPH36bTXOdP8w@mail.gmail.com>
Subject: filling buffers with data from block device
From: Alket Memushaj <amemushaj@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

is it possible to have fio fill the I/O buffers with data from a block
device? when testing systems with both deduplication and compression
enabled, it would be easier to fill the buffers with existing data.

thanks,
alket
