Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-io0-f177.google.com ([209.85.223.177]:33649 "EHLO
	mail-io0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751482AbcEMB70 (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 12 May 2016 21:59:26 -0400
Received: by mail-io0-f177.google.com with SMTP id f89so116041493ioi.0
        for <fio@vger.kernel.org>; Thu, 12 May 2016 18:59:26 -0700 (PDT)
MIME-Version: 1.0
Date: Fri, 13 May 2016 09:59:25 +0800
Message-ID: <CAGjEAhstKdQQQORoniayYLuvTdfXqAkOCXdargudF7oyeM0S5Q@mail.gmail.com>
Subject: file_service_type and random_distribution
From: qingwei wei <tchengwee@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hi,

I am looking at performing some small files benchmark and i would like
to confirm few things here:

1) Random distribution, for file type test, is this only applicable to
how it choose offset in the file?
2) file_service_type, is this decide which file to be opened during
test if i choose to have openfiles less than nrfiles?

I would like to confirm those points is because i intend to run
workload test that simulate hot file access. At any one time, the
files open will be less than the total files in the system and there
will be files that are hot and get access multiple times. Can i do it
using fio? Thanks.

Cw
