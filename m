Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-wg0-f49.google.com ([74.125.82.49]:35019 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753519AbbDHRBp (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 8 Apr 2015 13:01:45 -0400
Received: by wgyo15 with SMTP id o15so84034767wgy.2
        for <fio@vger.kernel.org>; Wed, 08 Apr 2015 10:01:44 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CABtFm2V2E2sZAhebJzxfxifcBJ95FzE8gTdQd+97CGJu2eNntQ@mail.gmail.com>
References: <CABtFm2V2E2sZAhebJzxfxifcBJ95FzE8gTdQd+97CGJu2eNntQ@mail.gmail.com>
Date: Wed, 8 Apr 2015 10:01:44 -0700
Message-ID: <CAF+0mvmYty_1X8xT747D0kbPwQDWhZXNevkeYW=5HvLjZkThjA@mail.gmail.com>
Subject: Re: Generating random data with FIO on directories returning null
From: Matthew Eaton <m.eaton82@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Srinivasa Chamarthy <chamarthy.raju@gmail.com>
Cc: fio@vger.kernel.org

> Am i doing something wrong here? My requirement is to generate random
> io and multiple files with different sizes.
>
> Thanks for any help.
>
> --
> Srinivasa R Chamarthy

This should be fixed if you update to latest fio from git.
