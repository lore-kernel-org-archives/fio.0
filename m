Return-Path: <vasu.kulkarni@gmail.com>
MIME-Version: 1.0
In-Reply-To: <CANvN+e=7M4A=g9ro1dmOJdC2NBj4+iEUaCYrwGfmGY+bpUsnNA@mail.gmail.com>
References: <CANvN+e=7M4A=g9ro1dmOJdC2NBj4+iEUaCYrwGfmGY+bpUsnNA@mail.gmail.com>
Date: Mon, 28 Jul 2014 11:21:10 -0700
Message-ID: <CAM8G_BJ3HNtZB6wjqFUiXSo4Zwzzqy7i34+2xkpvCENuzE0EHg@mail.gmail.com>
Subject: Re: Pull an external [global] section into an .fio file?
From: "Kulkarni, Vasu" <vasu.kulkarni@gmail.com>
Content-Type: text/plain; charset=UTF-8
To: Andrey Kuzmin <andrey.v.kuzmin@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

A workaround is to use separate file with globals and then append just
before you invoke fio
#cat globals.txt >> io.txt | fio io.txt

On Mon, Jul 28, 2014 at 10:42 AM, Andrey Kuzmin
<andrey.v.kuzmin@gmail.com> wrote:
> When dealing with a growing number of fio test scripts, copy/pasting
> global section becomes error-prone and cumbersome. Is it possible (or
> how much effort would it be to add such a feature) to pull a named set
> of global settings into the .fio file?
>
> Regards,
> Andrey
> --
> To unsubscribe from this list: send the line "unsubscribe fio" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
A ship is safer in a harbor.  But that's not what ships are built for.

