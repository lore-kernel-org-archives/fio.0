Return-Path: <axboe@kernel.dk>
Subject: Re: Fwd: Bug#929579: fio FTCBFS: builds for the build architecture
References: <2555177.PyF0XoxEVR@merkaba>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <ff0f9903-b060-c096-4fa0-bc3d3ffbd966@kernel.dk>
Date: Mon, 27 May 2019 09:23:50 -0600
MIME-Version: 1.0
In-Reply-To: <2555177.PyF0XoxEVR@merkaba>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
To: Martin Steigerwald <Martin.Steigerwald@proact.de>, "fio@vger.kernel.org" <fio@vger.kernel.org>
Cc: Helmut Grohne <helmut@subdivi.de>
List-ID: <fio@vger.kernel.org>

I'd be fine with that, if someone can submit a proper, separate patch
for it.


On 5/27/19 2:06 AM, Martin Steigerwald wrote:
> Hi Jens, hi Helmut. Jens, would the cross-build fixes contained in the attached debdiff (fio-3.12/debian/patches/cross.patch) be something you would consider applying upstream? I bet it could help other distributions with cross-building capabilities as well. Thank you, Martin ---------- Weitergeleitete Nachricht ---------- Betreff: Bug#929579: fio FTCBFS: builds for the build architecture Datum: Sonntag, 26. Mai 2019, 17:12:15 CEST Von: Helmut Grohne <helmut@subdivi.de> An: Debian Bug Tracking System <submit@bugs.debian.org> Source: fio Version: 3.12-2 Tags: patch User: helmutg@debian.org Usertags: rebootstrap fio fails to cross build from source, because it configures for the build architecture. fio's configure is very different from autotools and requires the user to export a variable called CROSS_COMPILE. Even then, it uses the wrong pkg-config and runs compiled executables. The attached patch makes fio cross buildable. Please consider applying it. Helmut 
> -------------------------------------------------------------
> Mit freundlichen Grüßen / With kind regards​
> 
> Martin Steigerwald	 •
> 	Proact Deutschland GmbH
> 
> Trainer
> 
> Telefon: *+49 911 30999 0* <tel:+49%20911%2030999%200>	 •
> 	Fax: *+49 911 30999 99* <tel:>
> 
> Südwestpark 43	 •
> 	90449 	Nürnberg	 •
> 	Germany
> 
> *Martin.Steigerwald@proact.de* <mailto:Martin.Steigerwald@proact.de>	 •
> 	*www.proact.de* <https://www.proact.de/>
> 
> Amtsgericht Nürnberg
> 	 •
> 	HRB 18320
> 
> Geschäftsführer:
> 	Oliver Kügow	 •
> 	Richard Müller	 •
> 	Jakob Høholdt
> 	 •
> 	Peter Mikael Javestad
> 
> – Delivering Business Agility –
> 
> Proact Wissenstag <https://go.proact.eu/Proact-Wissenstage-Anmeldung>
> 


-- 
Jens Axboe


