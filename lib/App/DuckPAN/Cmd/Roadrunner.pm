package App::DuckPAN::Cmd::Roadrunner;

use Moo;
with qw( App::DuckPAN::Cmd );

use MooX::Options;
use Time::HiRes qw( usleep );

sub run {
	my ( $self, @args ) = @_;

	if (-f 'dist.ini') {
		$self->app->print_text(
			"Found a dist.ini, suggesting a Dist::Zilla distribution",
		);
		$self->app->perl->cpanminus_install_error
			if (system("dzil authordeps --missing 2>/dev/null | grep -vP '[^\\w:]' | cpanm --quiet --notest --skip-satisfied"));
		$self->app->perl->cpanminus_install_error
			if (system("dzil listdeps --missing 2>/dev/null | grep -vP '[^\\w:]' | cpanm --quiet --notest --skip-satisfied"));
		$self->app->print_text(
			"Everything fine!",
		);
	} elsif (-f 'Makefile.PL') {
		$self->app->print_text(
			"Found a Makefile.PL",
		);
		$self->app->perl->cpanminus_install_error
			if (system("cpanm --quiet --notest --skip-satisfied --installdeps ."));
	} elsif (-f 'Build.PL') {
		$self->app->print_text(
			"Found a Build.PL",
		);
		$self->app->perl->cpanminus_install_error
			if (system("cpanm --quiet --notest --skip-satisfied --installdeps ."));
	}

	print "\a"; usleep 225000; print "\a";

}

1;