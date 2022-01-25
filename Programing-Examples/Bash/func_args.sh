
#!/bin/zsh

# this example shows how you can pass arguments to funcions


# the following needs to args

pass_arg() {
	echo "Your username is: $1"
}


# the arg we pass  (env var for a current user)
pass_arg $USER
