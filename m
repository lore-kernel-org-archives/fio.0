Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:34818 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754565Ab1ABOh0 (ORCPT <rfc822;fio@vger.kernel.org>);
	Sun, 2 Jan 2011 09:37:26 -0500
Received: by gyb11 with SMTP id 11so4957080gyb.19
        for <fio@vger.kernel.org>; Sun, 02 Jan 2011 06:37:26 -0800 (PST)
MIME-Version: 1.0
From: Dan Le <wb.danle@gmail.com>
Date: Sun, 2 Jan 2011 09:37:11 -0500
Message-ID: <AANLkTim2bn_eg3ZyVkOyni4by2X6VjFB31hj0RzVsXE6@mail.gmail.com>
Subject: What is random write of FIO?
Content-Type: text/plain; charset=UTF-8
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hi there,

I understand that FIO performs sequential writes of small files by
just sequentially flushing them into the file system. But for random
writes of either small or large files, how can FIO randomly write
those files into the file system? I am confused because the manual
does not clearly explain this feature.

Sorry for this newbie question. You answer will be appreciated.

-- Dan
