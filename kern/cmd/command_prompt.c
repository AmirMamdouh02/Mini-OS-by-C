#include <kern/cmd/command_prompt.h>
	#include <kern/proc/user_environment.h>
#include <kern/trap/kdebug.h>
#include <kern/cons/console.h>
#include "commands.h"

//TODO: [PROJECT MS1] [COMMAND PROMPT] auto-complete

//invoke the command prompt
void run_command_prompt()
{
	char command_line[1024];

	while (1==1)
	{
		//get command line
		readline("FOS> ", command_line);

		//parse and execute the command
		if (command_line != NULL)
			if (execute_command(command_line) < 0)
				break;
	}
}

/** Kernel command prompt command interpreter **/

//define the white-space symbols
#define WHITESPACE "\t\r\n "

//Function to parse any command and execute it
//(simply by calling its corresponding function)
int execute_command(char *command_string)
{
	// Split the command string into whitespace-separated arguments
	int number_of_arguments;
	//allocate array of char * of size MAX_ARGUMENTS = 16 found in string.h
	char *arguments[MAX_ARGUMENTS];


	strsplit(command_string, WHITESPACE, arguments, &number_of_arguments) ;
	if (number_of_arguments == 0)
		{
		return 0;
		}

	// Lookup in the commands array and execute the command
	int command_found = 0;
	int i ;

	int flag=0;
	for (i = 0; i < NUM_OF_COMMANDS; i++)
	{
		if (strcmp(arguments[0], commands[i].name) == 0)
		{
			command_found = 1;
			break;
		}
		else if(strncmp(arguments[0], commands[i].name,strlen(arguments[0]))== 0){
			cprintf("%s\n",commands[i].name);
		flag=1;
		}
	}

	if(command_found)
	{
		int return_value;
		return_value = commands[i].function_to_execute(number_of_arguments, arguments);
		return return_value;
	}
	else if(flag== 0){

		cprintf("Unknown command '%s'\n", arguments[0]);
		return 0;
	}
	else{
		return 0;
	}

	}




