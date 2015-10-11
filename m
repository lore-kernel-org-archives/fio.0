Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-ig0-f172.google.com ([209.85.213.172]:38807 "EHLO
	mail-ig0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751213AbbJKD5Z (ORCPT <rfc822;fio@vger.kernel.org>);
	Sat, 10 Oct 2015 23:57:25 -0400
Received: by igkz10 with SMTP id z10so26989706igk.1
        for <fio@vger.kernel.org>; Sat, 10 Oct 2015 20:57:24 -0700 (PDT)
MIME-Version: 1.0
Date: Sat, 10 Oct 2015 20:57:24 -0700
Message-ID: <CAF+0mvnWjT5wMpCZzsC6oN_7eobbsqGXdvqdJLxO9M0HFTH9UA@mail.gmail.com>
Subject: Threading vs forking
From: Matthew Eaton <m.eaton82@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hello fio group,

I have been wondering is there any point in telling fio to use threads
rather than forking on a linux platform? Is there any benefit?
