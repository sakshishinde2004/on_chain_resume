module ResumeBuilder::Resume {
    use std::string;
    use std::vector;
    use aptos_framework::account;
    
    /// Struct to store resume information
    struct ResumeInfo has key, store {
        name: string::String,
        skills: vector<string::String>,
        experience: vector<string::String>,
        owner: address,
        is_public: bool
    }

    /// Error codes
    const E_RESUME_EXISTS: u64 = 1;
    const E_RESUME_DOES_NOT_EXIST: u64 = 2;
    const E_NOT_OWNER: u64 = 3;

    /// Create a new resume for the user
    public entry fun create_resume(
        account: &signer,
        name: string::String,
        initial_skills: vector<string::String>,
        initial_experience: vector<string::String>,
        make_public: bool
    ) {
        let owner_addr = account::get_signer_address(account);
        
        // Check if resume already exists
        assert!(!exists<ResumeInfo>(owner_addr), E_RESUME_EXISTS);

        let resume = ResumeInfo {
            name,
            skills: initial_skills,
            experience: initial_experience,
            owner: owner_addr,
            is_public: make_public
        };

        move_to(account, resume);
    }

    /// Update existing resume with new information
    public entry fun update_resume(
        account: &signer,
        new_skills: vector<string::String>,
        new_experience: vector<string::String>,
        make_public: bool
    ) acquires ResumeInfo {
        let owner_addr = account::get_signer_address(account);
        
        // Check if resume exists
        assert!(exists<ResumeInfo>(owner_addr), E_RESUME_DOES_NOT_EXIST);
        
        let resume = borrow_global_mut<ResumeInfo>(owner_addr);
        assert!(resume.owner == owner_addr, E_NOT_OWNER);
        
        resume.skills = new_skills;
        resume.experience = new_experience;
        resume.is_public = make_public;
    }
}