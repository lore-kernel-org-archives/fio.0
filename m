Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-pl0-f46.google.com ([209.85.160.46]:46633 "EHLO
        mail-pl0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753342AbdKVWqi (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 22 Nov 2017 17:46:38 -0500
Received: by mail-pl0-f46.google.com with SMTP id k7so1564985pln.13
        for <fio@vger.kernel.org>; Wed, 22 Nov 2017 14:46:38 -0800 (PST)
MIME-Version: 1.0
From: Prabhakaran <prabhugce@gmail.com>
Date: Wed, 22 Nov 2017 15:46:37 -0700
Message-ID: <CAPqbHXh=+CXA1+Y0mmHbDmJauu53h6AmFNWW8ASWViP-LxKiEw@mail.gmail.com>
Subject: Running for a specific number of IOs
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hi,

Is there a parameter in FIO that can be used to run for a specific
number of IOs? I thought 'number_ios' might to this, but actually it
does fill 1x of the drive usable space and exits.

Thanks,
Prabhu
