Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-it0-f51.google.com ([209.85.214.51]:40773 "EHLO
        mail-it0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752788AbeDCTsR (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 3 Apr 2018 15:48:17 -0400
Received: by mail-it0-f51.google.com with SMTP id u62-v6so13564828ita.5
        for <fio@vger.kernel.org>; Tue, 03 Apr 2018 12:48:17 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAB-428nGSovor98bWztkQK3C0veSCK_ECey-yeBk2SahVXWFsA@mail.gmail.com>
References: <CAB-428nGSovor98bWztkQK3C0veSCK_ECey-yeBk2SahVXWFsA@mail.gmail.com>
From: Matthew Eaton <m.eaton82@gmail.com>
Date: Tue, 3 Apr 2018 12:48:16 -0700
Message-ID: <CAF+0mvk1tq03iVgVHGLMmarmG8XNjGqiWebSqBjJVUOEW5j-Lg@mail.gmail.com>
Subject: Re: Terse output header ?
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Alireza Haghdoost <haghdoost@gmail.com>
Cc: fio@vger.kernel.org

On Tue, Apr 3, 2018 at 11:18 AM, Alireza Haghdoost <haghdoost@gmail.com> wrote:
> Is there any way that we can get the full header with Terse output?
>
> Without a header, it prints a long line which is very hard to count
> and match the column with the definitions of columns in the howto
> guide. Moreover, some columns that are defined in the howto might be
> missing in my output and therefore, it makes the script development to
> use the terse output very hard.
>
>
> --
> Alireza
> --
> To unsubscribe from this list: send the line "unsubscribe fio" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

This might be helpful if you're using the default terse version.
https://www.andypeace.com/fio_minimal.html
