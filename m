Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-vk1-f181.google.com ([209.85.221.181]:42974 "EHLO
        mail-vk1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728649AbeKAAEH (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 31 Oct 2018 20:04:07 -0400
Received: by mail-vk1-f181.google.com with SMTP id m199-v6so3984615vke.9
        for <fio@vger.kernel.org>; Wed, 31 Oct 2018 08:05:44 -0700 (PDT)
MIME-Version: 1.0
References: <0f34b150-5f5f-6f01-9c19-e04830c9d4ee@gmail.com>
In-Reply-To: <0f34b150-5f5f-6f01-9c19-e04830c9d4ee@gmail.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Wed, 31 Oct 2018 15:05:16 +0000
Message-ID: <CALjAwxhSCN+5C9oRG34rdLc6NKnPUkNO+ND7X=p6fTWemuMsMg@mail.gmail.com>
Subject: Re: automated notification for fio releases
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Vincent Fu <vincentfu@gmail.com>
Cc: fio <fio@vger.kernel.org>

On Tue, 30 Oct 2018 at 20:26, Vincent Fu <vincentfu@gmail.com> wrote:
>
> Does anyone know of a means to be automatically notified of new fio
> releases?
>
> I have seen Jens post announcements via Twitter, but that is not a
> social media platform I actively use. As far as I can tell, Github does
> not provide a means to be notified of new releases.
>
> Perhaps the solution is to monitor http://brick.kernel.dk/snaps/ for new
> fio shortlog files.

I think there are few things that are doing monitoring of this.
Repology ( https://repology.org/metapackage/fio/packages ) seems to
have some way of knowing, Fedora seem to use
https://release-monitoring.org/project/806/ and I think Debian have
their own watcher (https://qa.debian.org/cgi-bin/watch?pkg=fio ). You
might also be able to tell via github
(https://github.com/axboe/fio/releases and I think there are atom
feeds off that page).

-- 
Sitsofe | http://sucs.org/~sits/

