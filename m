Return-Path: <sitsofe@gmail.com>
MIME-Version: 1.0
References: <20200727031638.28264-1-dmitry.fomichev@wdc.com>
 <20200727031638.28264-2-dmitry.fomichev@wdc.com> <CY4PR04MB37518C4372FBF5B4203D468AE7720@CY4PR04MB3751.namprd04.prod.outlook.com>
In-Reply-To: <CY4PR04MB37518C4372FBF5B4203D468AE7720@CY4PR04MB3751.namprd04.prod.outlook.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Mon, 27 Jul 2020 06:23:04 +0100
Message-ID: <CALjAwxjdDCKJiW-1gUun=j7Tn8rLL4EhTPDtt5NtD=wRrUn0bw@mail.gmail.com>
Subject: Re: [PATCH 1/3] configure: improve libzbc version check
Content-Type: text/plain; charset="UTF-8"
To: Damien Le Moal <Damien.LeMoal@wdc.com>
Cc: Dmitry Fomichev <Dmitry.Fomichev@wdc.com>, Jens Axboe <axboe@kernel.dk>, "fio@vger.kernel.org" <fio@vger.kernel.org>, Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
List-ID: <fio@vger.kernel.org>

On Mon, 27 Jul 2020 at 06:05, Damien Le Moal <Damien.LeMoal@wdc.com> wrote:
>
> On 2020/07/27 12:16, Dmitry Fomichev wrote:
> > Avoid parsing pkg-config output and just use --atleast-version to
> > check if libzbc is present and has an up to date version. Since
> > this process may fail because pkg-config is not installed, verify
> > pkg-config presence and warn the user if it was not found.
> >
> > Signed-off-by: Dmitry Fomichev <dmitry.fomichev@wdc.com>
> > ---
> >  configure | 9 ++++++---
> >  1 file changed, 6 insertions(+), 3 deletions(-)
> >
> > diff --git a/configure b/configure
> > index 5925e94f..0c4a96ec 100755
> > --- a/configure
> > +++ b/configure
> > @@ -2467,11 +2467,14 @@ int main(int argc, char **argv)
> >  }
> >  EOF
> >  if compile_prog "" "-lzbc" "libzbc"; then
> > -  libzbcvermaj=$(pkg-config --modversion libzbc | sed 's/\.[0-9]*\.[0-9]*//')
> > -  if test "$libzbcvermaj" -ge "5" ; then
> > +  if $(pkg-config --atleast-version=5 libzbc); then

Should this really be being done in a subshell? If it weren't done in
a subshell wouldn't the if have failed due to a lack of pkg-config:

% if not-pkg-config --atleast-version=5 libzbc; then echo y; else echo n; fi
zsh: command not found: not-pkg-config
n

-- 
Sitsofe | http://sucs.org/~sits/

