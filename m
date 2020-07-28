Return-Path: <sitsofe@gmail.com>
MIME-Version: 1.0
References: <20200727031638.28264-1-dmitry.fomichev@wdc.com>
 <20200727031638.28264-2-dmitry.fomichev@wdc.com> <CY4PR04MB37518C4372FBF5B4203D468AE7720@CY4PR04MB3751.namprd04.prod.outlook.com>
 <CALjAwxjdDCKJiW-1gUun=j7Tn8rLL4EhTPDtt5NtD=wRrUn0bw@mail.gmail.com> <MN2PR04MB59510EA6CF8FA08958D3603EE1730@MN2PR04MB5951.namprd04.prod.outlook.com>
In-Reply-To: <MN2PR04MB59510EA6CF8FA08958D3603EE1730@MN2PR04MB5951.namprd04.prod.outlook.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Tue, 28 Jul 2020 22:23:10 +0100
Message-ID: <CALjAwxhS=kMGZNgcLmqG=r7KnMMN21snk9xkMXOis=5w3X4+fw@mail.gmail.com>
Subject: Re: [PATCH 1/3] configure: improve libzbc version check
Content-Type: text/plain; charset="UTF-8"
To: Dmitry Fomichev <Dmitry.Fomichev@wdc.com>
Cc: Damien Le Moal <Damien.LeMoal@wdc.com>, Jens Axboe <axboe@kernel.dk>, "fio@vger.kernel.org" <fio@vger.kernel.org>, Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
List-ID: <fio@vger.kernel.org>

On Tue, 28 Jul 2020 at 20:58, Dmitry Fomichev <Dmitry.Fomichev@wdc.com> wrote:
>
> > -----Original Message-----
> > From: Sitsofe Wheeler <sitsofe@gmail.com>
> > Sent: Monday, July 27, 2020 1:23 AM
> > To: Damien Le Moal <Damien.LeMoal@wdc.com>
> > Cc: Dmitry Fomichev <Dmitry.Fomichev@wdc.com>; Jens Axboe
> > <axboe@kernel.dk>; fio@vger.kernel.org; Shinichiro Kawasaki
> > <shinichiro.kawasaki@wdc.com>
> > Subject: Re: [PATCH 1/3] configure: improve libzbc version check
> >
> > On Mon, 27 Jul 2020 at 06:05, Damien Le Moal <Damien.LeMoal@wdc.com>
> > wrote:
> > >
> > > On 2020/07/27 12:16, Dmitry Fomichev wrote:
> > > > Avoid parsing pkg-config output and just use --atleast-version to
> > > > check if libzbc is present and has an up to date version. Since
> > > > this process may fail because pkg-config is not installed, verify
> > > > pkg-config presence and warn the user if it was not found.
> > > >
> > > > Signed-off-by: Dmitry Fomichev <dmitry.fomichev@wdc.com>
> > > > ---
> > > >  configure | 9 ++++++---
> > > >  1 file changed, 6 insertions(+), 3 deletions(-)
> > > >
> > > > diff --git a/configure b/configure
> > > > index 5925e94f..0c4a96ec 100755
> > > > --- a/configure
> > > > +++ b/configure
> > > > @@ -2467,11 +2467,14 @@ int main(int argc, char **argv)
> > > >  }
> > > >  EOF
> > > >  if compile_prog "" "-lzbc" "libzbc"; then
> > > > -  libzbcvermaj=$(pkg-config --modversion libzbc | sed 's/\.[0-9]*\.[0-
> > 9]*//')
> > > > -  if test "$libzbcvermaj" -ge "5" ; then
> > > > +  if $(pkg-config --atleast-version=5 libzbc); then
> >
> > Should this really be being done in a subshell? If it weren't done in
> > a subshell wouldn't the if have failed due to a lack of pkg-config:
> >
> > % if not-pkg-config --atleast-version=5 libzbc; then echo y; else echo n; fi
> > zsh: command not found: not-pkg-config
> > n
>
> This line now does the same thing that is done to check libiscsi and libnbd
> minimum versions in the same script. It works fine if pkg-config is installed
> in the system. The version without the subshell also works, but it outputs
> an additional error message if pkg-config is not installed -
>
> ./configure: line 2470: not-pkg-config: command not found
> libzbc engine                 missing pkg-config, can't check library version
>
> I could remove the explicit check for pkg-config and do the version check
> without the subshell, but I think the output is less confusing with the subshell
> version.

OK I see what you mean. Would it be better to have an explicit
pkg-config check for all those engines?

(There is also a general issue that fio's pkg-config usage won't cope
well in cross compile environments but that's another issue...)

-- 
Sitsofe | http://sucs.org/~sits/

