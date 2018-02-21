Return-Path: <sitsofe@gmail.com>
MIME-Version: 1.0
In-Reply-To: <CY1PR0401MB111641A66DF1AC0E016E97E181CE0@CY1PR0401MB1116.namprd04.prod.outlook.com>
References: <CY1PR0401MB11163E6C999998E0A2F13F9E81F70@CY1PR0401MB1116.namprd04.prod.outlook.com>
 <CY1PR0401MB111689EE46B3839EB0675D7B81F70@CY1PR0401MB1116.namprd04.prod.outlook.com>
 <CY1PR0401MB1116307F93264CDB7F09870981F70@CY1PR0401MB1116.namprd04.prod.outlook.com>
 <CALjAwxhHoS62hDsz9cvwjYBJFODDZ6EvTry9u4nErXAC67JwKg@mail.gmail.com>
 <CY1PR0401MB111673C9DC353353BACFCE5B81F50@CY1PR0401MB1116.namprd04.prod.outlook.com>
 <CY1PR0401MB1116FC09283C22316161F3E381CE0@CY1PR0401MB1116.namprd04.prod.outlook.com>
 <CALjAwxgi-muVZ4XVF53amSHOzLjMEDSY2Z2GRmKso_VZ1sVazA@mail.gmail.com>
 <CY1PR0401MB11163A5F0CE792CC28A7252D81CE0@CY1PR0401MB1116.namprd04.prod.outlook.com>
 <CALjAwxiso_3xAjP1CJ91=qXcsyKcwzN2XfBeGLvPzeMj45BLGQ@mail.gmail.com> <CY1PR0401MB111641A66DF1AC0E016E97E181CE0@CY1PR0401MB1116.namprd04.prod.outlook.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Wed, 21 Feb 2018 18:24:57 +0000
Message-ID: <CALjAwxjmz4t_rbXuDwqPmiAPXUg_h88qvcRUGbXPCRAnDcw8Qg@mail.gmail.com>
Subject: Re: fiologparser_hist.py script patch and enhancements?
Content-Type: text/plain; charset="UTF-8"
To: Kris Davis <Kris.Davis@wdc.com>
Cc: Vincent Fu <vincentfu@gmail.com>, Vincent Fu <Vincent.Fu@wdc.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>
List-ID: <fio@vger.kernel.org>

For what it's worth I feel your pain and I think it's impossible to
win until there's only one version of Python actively left. My hope is
by making it consistent across all the fio scripts everyone will be
the same jam and will at least be able to do a find/replace.

Perhaps someone should suggest a PEP which is an interpreter line that
is just a line like preferredpython[2,3] and everyone is just expected
to run a small conversion tool before starting to use it. Said
conversion tool can rewrite the line to be env based, absolute, prefer
python 3 to python 2 if when it's a Sunday and the weather's good...

On 21 February 2018 at 17:45, Kris Davis <Kris.Davis@wdc.com> wrote:
> Sigh...
> So much for trying to have it work for either python3 or python2.
>
> The doc you referenced does say: "If the executables provide the same functionality independent of whether they are run on top of Python 2 or Python 3, then only the Python 3 version of the executable should be packaged."
>
> However, since 2.7 runs so much faster, and 2.7 is still the default for the near future, I agree we should stay with 2.7.   I'll back out that tweak and create a new patch.

-- 
Sitsofe | http://sucs.org/~sits/

