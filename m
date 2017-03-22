Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-it0-f43.google.com ([209.85.214.43]:38011 "EHLO
        mail-it0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1758908AbdCVIMf (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 22 Mar 2017 04:12:35 -0400
Received: by mail-it0-f43.google.com with SMTP id y18so21347314itc.1
        for <fio@vger.kernel.org>; Wed, 22 Mar 2017 01:12:34 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <8709584e-1ea6-e031-a0dc-5a9d8ec915ce@fb.com>
References: <20170321211632.38104-1-gwendal@chromium.org> <8709584e-1ea6-e031-a0dc-5a9d8ec915ce@fb.com>
From: Gwendal Grignou <gwendal@chromium.org>
Date: Wed, 22 Mar 2017 01:12:13 -0700
Message-ID: <CAMHSBOV3YTGiWjN4EMyFVD4DT4XnzMWmnBTA+zsgWziaf8EABA@mail.gmail.com>
Subject: Re: [PATCH] Ensure all json field keys do not have ' ' in them
Content-Type: text/plain; charset=UTF-8
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Jens Axboe <axboe@fb.com>
Cc: fio@vger.kernel.org

On Tue, Mar 21, 2017 at 8:51 PM, Jens Axboe <axboe@fb.com> wrote:
> On 03/21/2017 05:16 PM, Gwendal Grignou wrote:
>> So far, fio key names use '_' instead of ' '.
>> Fix keys with 'job options' and 'global options' to match the naming
>> convention.
>
> Is there a problem with the outputted json?
No the json file is correct, and it is acceptable to have spaces in keys.
> I agree it would be
> cleaner to have the underscore instead of the space, but this
> change might also break scripts that parse the existing
> output. So we need a good reason to change it, which isn't
> just a cosmetic concern.
Most cosmetic: the spaces were breaking a script around older version
of fio, but it is a script issue, no a fio issue.
>
> Just curious what your motivations are for the change.
>
I understand it is too late to change fio, so ignore the patch.
> --
> Jens Axboe
>
