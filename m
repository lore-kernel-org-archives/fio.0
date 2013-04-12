Return-Path: <xaaronc@gmail.com>
MIME-Version: 1.0
In-Reply-To: <20130412063005.GG12244@kernel.dk>
References: <CAKCZDgnM85AcwD6Ss5YWNjXwY-OE7QFQh22nFdEFHkta_N0hRA@mail.gmail.com>
	<F36FEB27-8751-4321-8E58-661924945DCE@intel.com>
	<CAKCZDgkbxsgB-LDLSSJr3bm2j-aEj783kLT52h9emb18Rs1pUg@mail.gmail.com>
	<1C4A98C0-A6F6-4E57-8A97-C4E8D253D819@intel.com>
	<CAKCZDgmiGQFX1kHrjA9zR_LJLxw-rBotyCXegqQG0gdN99cOtg@mail.gmail.com>
	<CAKCZDgkybSpM5r6b46qO7MsRy6BdFW3O_CAGtoc=8N4zSB5Lpg@mail.gmail.com>
	<20130412055808.GE12244@kernel.dk>
	<CAKCZDg=sNxp+mAwTQfBthm-9n=kN2yKgWG52hmmaRBAr+K9fHA@mail.gmail.com>
	<20130412061806.GF12244@kernel.dk>
	<CAKCZDgkF-Pa=5Xzz-PSrFNTjrW-TY2FoQa2m0YpshtLa5SssOw@mail.gmail.com>
	<20130412063005.GG12244@kernel.dk>
Date: Fri, 12 Apr 2013 16:34:34 +1000
Message-ID: <CAKCZDg=yf2y6hiSoxEExkEo91txMn3HEp7TVovDAmVwJK_M6mw@mail.gmail.com>
Subject: Re: Make FIO for Android
From: Aaron Carroll <xaaronc@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
To: Jens Axboe <axboe@kernel.dk>
Cc: "Krishnamurthy, Anush" <anush.krishnamurthy@intel.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 12 April 2013 16:30, Jens Axboe <axboe@kernel.dk> wrote:
> Great, thanks! Will see if I can't get that asm android happy too.

Thanks.  Does it make sense to use the GCC builtin __get_cpuid() ?
That seems to build fine both native x86 and Android/x86 here.

