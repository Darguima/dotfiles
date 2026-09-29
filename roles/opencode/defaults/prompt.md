I am setting up my OpenCode AI coding assistant configuration which utilizes five distinct agents to balance high performance and cost-efficiency. I will provide you with a JSON list of currently available models. Your task is to analyze the list and select the most appropriate models for each agent based on their specific roles.

Here is the context for how my OpenCode environment is organized:
1. **Plan Pro Agent**: For complex architectural planning. Needs the absolute most powerful, high-reasoning model available (e.g., "pro", "max"). Most expensive tier is acceptable. Does not edit code.
2. **Plan Agent**: For standard planning and task breakdown. Needs a solid reasoning model, but cost-effective (e.g., "plus", high-tier standard). Does not edit code.
3. **Build Pro Agent**: For complex implementation and severe bug fixing. Needs a highly capable coding model (e.g., top-tier "code", "pro").
4. **Build Agent**: For standard coding tasks and boilerplate. Needs a fast, cost-effective coding model (e.g., "flash", standard "code").
5. **Chat Agent**: Conversational assistant for brainstorming. Needs to be very fast and cheap (e.g., "flash", "omni").

Selection Criteria:
Select ONE optimal model for each of the 5 roles from the provided JSON list, strictly balancing the requirement of "Pro" models being highly capable and standard models being cost-effective.

Output Requirements:
You must output the final selection strictly in the exact format below. After you can include other text like explanations for the choice.

opencode_plan_pro_model: "<model_id>" # another cheaper possible model
opencode_plan_model: "<model_id>" # another cheaper possible model
opencode_build_pro_model: "<model_id>" # another cheaper possible model
opencode_build_model: "<model_id>" # another cheaper possible model
opencode_chat_model: "<model_id>" # another cheaper possible model