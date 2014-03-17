Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-ve0-f175.google.com ([209.85.128.175]:50741 "EHLO
	mail-ve0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755818AbaCQCzH (ORCPT <rfc822;fio@vger.kernel.org>);
	Sun, 16 Mar 2014 22:55:07 -0400
Received: by mail-ve0-f175.google.com with SMTP id oz11so5046725veb.20
        for <fio@vger.kernel.org>; Sun, 16 Mar 2014 19:55:06 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAF+0mvmJqfvzdDrj8qWxmfgAh7jM9=f20v2pMTpFU-75vuTFRw@mail.gmail.com>
References: <53243539.5010405@adon.li>
	<CACVXFVNbNpwH44DHfN+BU2a7KvF=Ah7As3+UwKHB8eGOX6b7ug@mail.gmail.com>
	<CAF+0mvmJqfvzdDrj8qWxmfgAh7jM9=f20v2pMTpFU-75vuTFRw@mail.gmail.com>
Date: Mon, 17 Mar 2014 10:55:06 +0800
Message-ID: <CACVXFVN9O7HF6LJ=k-mygGHLWcpsQ3chWkkukdp+rFqnunJ60w@mail.gmail.com>
Subject: Re: correct file size to use
From: Ming Lei <tom.leiming@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Matthew Eaton <m.eaton82@gmail.com>
Cc: jvogt <jvogt@adon.li>, fio@vger.kernel.org

On Mon, Mar 17, 2014 at 7:16 AM, Matthew Eaton
>
> Tested on my system and saw no difference in performance.  Direct io
> will bypass the page cache so the only thing that comes to mind would

Looks I miss the '--direct=1' parameter, :-(

> be an on-device cache, though, I would think the difference in
> performance would be more dramatic if that were the case.

Another possible cause might be related with storage for the
big file. If the file is stored in lot of fragments of the disk, accessing
the whole file might become slower than just the first 10M, but not
sure if there is so big difference(30%).


Thanks,
-- 
Ming Lei
