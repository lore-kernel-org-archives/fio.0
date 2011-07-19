Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-gw0-f46.google.com ([74.125.83.46]:48461 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750868Ab1GSAVx (ORCPT <rfc822;fio@vger.kernel.org>);
	Mon, 18 Jul 2011 20:21:53 -0400
Received: by gwaa18 with SMTP id a18so1551753gwa.19
        for <fio@vger.kernel.org>; Mon, 18 Jul 2011 17:21:53 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CANWz5fg0RmLJVvfUevz7owHzasYtiNrMyFajgmnF6_QUOk44-A@mail.gmail.com>
References: <CAAZKuFauk_dFsN-H5-r5+PjTL2F1ay1bzkGyYWpY0WVhHAW2uw@mail.gmail.com>
 <CANWz5fg4i5Wj9B2-719H19=7TRJty5SDrZZ=2GQv8YiKPzkWqg@mail.gmail.com>
 <CAAZKuFY+iZvtS8MpVBA6rYfsk-wwKqL6HZ66wGCjqXcyZXHkcg@mail.gmail.com>
 <CANWz5fi-=P5J=Op5o7-pr+3UMh+CLQMsnctem8hhOG2RnHuiLA@mail.gmail.com>
 <CAAZKuFYWPYhgpOTBGvETE+WGO9Cd+pHEr=4YJF07GHP1UZTy8g@mail.gmail.com>
 <CANWz5fg+a0O1tTk=FPpgR4dDGHZxaSnBP0W03FeNUFGccMMGKA@mail.gmail.com>
 <CAAZKuFY=QEXqSD0uHYY0u8E4uiJf2xKWbQAsKde3DWcd6jOhpw@mail.gmail.com> <CANWz5fg0RmLJVvfUevz7owHzasYtiNrMyFajgmnF6_QUOk44-A@mail.gmail.com>
From: Daniel Farina <daniel@heroku.com>
Date: Mon, 18 Jul 2011 17:21:33 -0700
Message-ID: <CAAZKuFZ2WdK8YkLuo9ayyHe4=pv8+F7Tm1-cBO=JiQtuW5tLtA@mail.gmail.com>
Subject: Re: fio: when not using a job file, timeouts are not applied
Content-Type: text/plain; charset=ISO-8859-1
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Chris Worley <worleys@gmail.com>
Cc: fio@vger.kernel.org

On Mon, Jul 18, 2011 at 5:19 PM, Chris Worley <worleys@gmail.com> wrote:
> Do you mean to be using --timeout or --runtime?

--timeout.  It's pretty clear the semantics using a job file and those
without a job file are not the same, or are you not able to reproduce
this?

-- 
fdr
