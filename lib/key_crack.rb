module KeyCrack

  def absolute_key_shift
    index_encrypted_end = convert_to_index(encrypted_end)
    neg_index_decrypted_end = convert_to_negative_index(decrypted_end)
    neg_date_shift_end = convert_to_negative_date_shift(shift_type_end)
    raw_key_shift = index_encrypted_end.zip(neg_index_decrypted_end, neg_date_shift_end).map(&:sum)
    raw_key_shift.map {|key| key.negative? ? key += 27 : key}
  end

  def convert_key_to_string(key_integer)
    key_integer.to_s.length == 1 ? "0#{key_integer.to_s}" : key_integer.to_s
  end

  def all_possible_key_shifts
    all_possible_keys = absolute_key_shift.map do |key|
      all_key_shifts = []
      all_key_shifts << key_shift = key
      until key_shift > 100
        key_shift += 27
        all_key_shifts << key_shift if key_shift < 100
      end
      all_key_shifts.map {|key| convert_key_to_string(key)}
    end
    rotate_to_abcd_order(all_possible_keys)
  end

  def keys_by_shift
    [:alpha, :beta, :gamma, :delta].zip(all_possible_key_shifts).to_h
  end

  def beta_matched_keys
    matches = Hash.new{|h,k| h[k] = []}
    keys_by_shift[:beta].each do |beta_key|
      keys_by_shift[:alpha].each do |alpha_key|
        matches[:a_b] << beta_key if beta_key[0] == alpha_key[1]
      end
      keys_by_shift[:gamma].each do |gamma_key|
        matches[:b_c] << beta_key if beta_key[1] == gamma_key[0]
      end
    end
    matches[:a_b].select { |key| matches[:b_c].include?(key) }
  end

  def gamma_matched_keys(matched_keys)
    matches = Hash.new{|h,k| h[k] = []}
    keys_by_shift[:gamma].each do |gamma_key|
      keys_by_shift[:delta].each do |delta_key|
        matches[:c_d] << gamma_key if delta_key[0] == gamma_key[1]
      end
      matched_keys[:beta].each do |beta_key|
        matches[:c_b] << gamma_key if beta_key[1] == gamma_key[0]
      end
    end
    matches[:c_d].select { |key| matches[:c_b].include?(key) }
  end

  def alpha_matched_keys(matched_keys)
    matches = []
    keys_by_shift[:alpha].each do |alpha_key|
      matched_keys[:beta].each do |beta_key|
        matches << alpha_key if alpha_key[1] == beta_key[0]
      end
    end
    matches
  end

  def delta_matched_keys(matched_keys)
    matches = []
    keys_by_shift[:delta].each do |delta_key|
      matched_keys[:gamma].each do |gamma_key|
        matches << delta_key if gamma_key[1] == delta_key[0]
      end
    end
    matches
  end


  def all_matched_key_shifts
    matched_keys = Hash.new{|h,k| h[k] = []}
    #b key match
    matched_keys[:beta] = beta_matched_keys
    #a key match
    matched_keys[:alpha] = alpha_matched_keys(matched_keys)
    #c key match
    matched_keys[:gamma] = gamma_matched_keys(matched_keys)
    #d key matches
    matched_keys[:delta] = delta_matched_keys(matched_keys)
    matched_keys
  end

  def list_of_possible_keys
    keys_hash = all_matched_key_shifts
    keys = []
    if all_matched_key_shifts.all? {|shift_type, matched_keys| matched_keys.length == 1}
      keys << combined_key(keys_hash[:alpha][0], keys_hash[:gamma][0], keys_hash[:delta][0])
    else
      keys = multiple_keys_scenario(keys_hash)
    end
    keys
  end

  def combined_key(alpha_key, gamma_key, delta_key)
    alpha_key + gamma_key + delta_key[1]
  end

  def multiple_keys_scenario(keys_hash)
    keys = []
    keys_hash[:alpha].each do |alpha_key|
      keys_hash[:beta].each do |beta_key|
        keys_hash[:gamma].each do |gamma_key|
          keys_hash[:delta].each do |delta_key|
            if valid_key?(alpha_key, beta_key, gamma_key, delta_key)
              keys << combined_key(alpha_key, gamma_key, delta_key)
            end
          end
        end
      end
    end
    keys
  end

  def valid_key?(a_key, b_key, c_key, d_key)
    a_key[1] == b_key[0] &&
      b_key[1] == c_key[0] &&
      c_key[1] == d_key[0]
  end
end