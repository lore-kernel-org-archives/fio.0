Return-Path: <erwan@enovance.com>
Message-ID: <54E5D468.1070200@enovance.com>
Date: Thu, 19 Feb 2015 13:17:44 +0100
From: Erwan Velu <erwan@enovance.com>
MIME-Version: 1.0
Subject: Re: Potential leaks & errors on current trunk
References: <54E35788.2000400@enovance.com> <54E4DBB7.7080705@kernel.dk>
In-Reply-To: <54E4DBB7.7080705@kernel.dk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable
To: Jens Axboe <axboe@kernel.dk>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>


Le 18/02/2015 19:36, Jens Axboe a =C3=A9crit :
>
>> http://git.kernel.dk/?p=3Dfio.git;a=3Dblob;f=3Diolog.c;h=3D99f8bc18d86=
94cca0c141c51d116aced1b4130f2;hb=3DHEAD#l863=20
>>
>>
>> In that function, if we do return 1 we do leak ic.buf, we shall free i=
t
>> before the return
>
> Yep, there's a potential leak or two there, should be fixed up.
>
>> http://git.kernel.dk/?p=3Dfio.git;a=3Dblob;f=3Dlib/axmap.c;h=3D164300f=
254014b10ed6e04e3e06b7263aa917aac;hb=3DHEAD#l127=20
>>
>>
>> Here, we surely miss the free of the axmap. We did free its internal
>> structure but not axmap itself.
>
> Yes, that should free 'axmap' too of course.
>

Hey Jens,

I don't know your workflow : do you accept pull request directly on githu=
b ?

At least, please find the two commits for that issues in my repo :=20
https://github.com/enovance/fio/tree/erwan/memory-leak

Cheers,

--=20
Erwan Velu
eNovance from Redhat


